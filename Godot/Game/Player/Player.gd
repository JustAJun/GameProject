extends KinematicBody2D

export(int) var MAX_SPEED = 500
export(int) var ACCEL = 3000
export(int) var FRICTION = 3000
var vel = Vector2.ZERO

enum {
	MOVE,
	ATTACK,
	DEAD
}
var state = MOVE

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var playerHitbox = $Pivot/PlayerHitbox
onready var playerHurtbox = $Hurtbox
onready var stats = PlayerStats
onready var softCol = $SoftCollisions

func _ready():
	randomize()
	animationTree.active = true
	playerHitbox.damage = stats.damage
	stats.connect("no_health", self, "player_death")
	stats.connect("damage_changed", self, "set_damage")
	

func _process(delta):
	match state:
		MOVE:
			playerMove(delta)
		ATTACK:
			playerAttack()
		DEAD:
			vel = Vector2.ZERO
			animationState.travel("Death")
			collision_layer = 0
			

func playerMove(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	inputVector.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	inputVector = inputVector.normalized()
	if inputVector != Vector2.ZERO:
		playerHitbox.knockbackVector = inputVector
		animationTree.set("parameters/Idle/blend_position", inputVector)
		animationTree.set("parameters/Run/blend_position", inputVector)
		animationTree.set("parameters/Attack/blend_position", inputVector)
		animationTree.set("parameters/Death/blend_position", inputVector)
		animationState.travel("Run")
		vel = vel.move_toward(inputVector * MAX_SPEED, ACCEL * delta)
	else:
		animationState.travel("Idle")
		vel = vel.move_toward(Vector2.ZERO, FRICTION * delta)
		
			
	if softCol.is_colliding():
		vel += softCol.get_push_vector() * delta * 2000
	vel = move_and_slide(vel)
	
	if Input.is_action_just_pressed("player_attack"):
		var attackVector = global_position.direction_to(get_global_mouse_position())
		animationTree.set("parameters/Attack/blend_position",attackVector)
		state = ATTACK
	if Input.is_action_just_pressed("fast_permission"):
		position = get_global_mouse_position()

func playerAttack():
	vel = Vector2.ZERO
	animationState.travel("Attack")

func playerAttackFinished():
	state = MOVE

func _on_Hurtbox_area_entered(area):
	if area.can_damage:
		stats.health -= area.damage
		
func player_death():
	state = DEAD
	get_tree().get_root().get_node("Arena/AudioStreamPlayer").stop()
	
func set_damage(value):
	playerHitbox.damage = value
