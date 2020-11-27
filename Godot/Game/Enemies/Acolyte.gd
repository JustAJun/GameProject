extends KinematicBody2D

export(int) var MAX_SPEED = 200
export(int) var ACCEL = 2000
export(int) var FRICTION = 3000
export(int) var WANDER_TARGET_RANGE = 10
var velocity = Vector2.ZERO

#                        Animation
onready var animation = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	DEAD
}
var state = IDLE
var knockback = Vector2.ZERO
onready var stats = $Stats
onready var detectionZone = $DetectionZone
onready var attackZone = $AttackZone
onready var hitbox = $AttackZone/AttackPivot/Hitbox
onready var softCollisions = $SoftCollisions
onready var wanderController = $WanderController
onready var enemyInfo = $EnemyLevel
var direction = Vector2.ZERO

func _ready():
	animationTree.active = true
	stats.connect("no_health", self, "enemy_death")
	stats.connect("damage_changed", self, "set_damage")
	stats.connect("level_changed", self, "set_level")
	state = choose_random_state([IDLE, WANDER])
	hitbox.damage = stats.damage
	set_level(stats.level)
	

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	var player = detectionZone.player
	if player != null:
		 direction = global_position.direction_to(player.global_position)
		
	animationTree.set("parameters/Idle/blend_position", direction)
	animationTree.set("parameters/Run/blend_position", direction)
	animationTree.set("parameters/Attack/blend_position",direction)
		
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			animationState.travel("Idle")
			
			if wanderController.get_time_left() == 0:
				state = choose_random_state([IDLE, WANDER])
				wanderController.start_wander_time(rand_range(1,3))
			
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				state = choose_random_state([IDLE, WANDER])
				wanderController.start_wander_time(rand_range(1,3))
				
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				state = choose_random_state([IDLE, WANDER])
				wanderController.start_wander_time(rand_range(1,3))
#				pass	

			direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCEL * delta)
			animationState.travel("Run")
			
			
		CHASE:
			if player != null:
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCEL * delta)
				animationState.travel("Run")
				if attackZone.can_attack:
					state = ATTACK
			else:
				 state = IDLE
				
		ATTACK:
			attack_Player()
			
		DEAD:
			velocity = Vector2.ZERO
			collision_layer = 0
			
	if softCollisions.is_colliding():
		velocity += softCollisions.get_push_vector() * delta * 2000
		
	velocity = move_and_slide(velocity)

func seek_player():
	if detectionZone.can_see_player():
		state = CHASE
		
func choose_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	

func _on_Hurtbox_area_entered(area):
	knockback = area.knockbackVector * 300
	stats.health -= area.damage


			# ATTACK
func attack_Player():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_Animation_Finished(): 
	if detectionZone.can_see_player():
		state = CHASE  #если игрок не в зоне атаки и в зоне агра, то преследовать
	else:
		state = IDLE  #сделать выбор дальнейшего состояния рандомным (IDLE или WANDER)

func enemy_death():
	state = DEAD
	animationTree.set("parameters/Death/blend_position", direction)
	animationState.travel("Death")
	get_tree().get_root().get_node("/root/PlayerStats").xp += stats.default_xp * stats.level

func set_damage(value):
	hitbox.damage = value
	print("DMG = ", value)
	
func set_level(value):
	enemyInfo.text = "Lvl " + str(value)
