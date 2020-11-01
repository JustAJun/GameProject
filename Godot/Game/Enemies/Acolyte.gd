extends KinematicBody2D

export(int) var MAX_SPEED = 200
export(int) var ACCEL = 2000
export(int) var FRICTION = 3000
var velocity = Vector2.ZERO

#                        Animation
onready var animation = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}
var state = IDLE
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var detectionZone = $DetectionZone
onready var attackZone = $AttackZone

var direction

func _ready():
	animationTree.active = true
	

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	var player = detectionZone.player
	if player != null:
		 direction = (player.global_position - global_position).normalized()
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			animationTree.set("parameters/Idle/blend_position", velocity)
			animationState.travel("Idle")
			
		WANDER:
			seek_player()
			
		CHASE:
			if player != null:
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCEL * delta)
				animationTree.set("parameters/Run/blend_position", direction)
				animationState.travel("Run")
				if attackZone.can_attack:
					state = ATTACK
			else:
				 state = IDLE
				
		ATTACK:
			attack_Player(direction)
			
	velocity = move_and_slide(velocity)

func seek_player():
	if detectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	knockback = area.knockbackVector * 300
	stats.health -= area.damage

func _on_Stats_no_health():
	queue_free()



			# ATTACK
func attack_Player(dir):
	velocity = Vector2.ZERO
	animationTree.set("parameters/Attack/blend_position",dir)
	animationState.travel("Attack")

func attack_Animation_Finished(): 
	if detectionZone.can_see_player():
		state = CHASE # если игрок не в зоне атаки и в зоне агра, то преследовать
	else:
		state = IDLE  #сделать выбор дальнейшего состояния рандомным (IDLE или WANDER)
