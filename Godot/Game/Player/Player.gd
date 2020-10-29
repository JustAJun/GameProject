extends KinematicBody2D

export(int) var MAX_SPEED = 500
export(int) var ACCEL = 3000
export(int) var FRICTION = 3000
var vel = Vector2.ZERO

enum {
	MOVE,
	ATTACK
}
var state = MOVE

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var playerHitbox = $Pivot/PlayerHitbox

func _ready():
	animationTree.active = true

func _process(delta):
	match state:
		MOVE:
			playerMove(delta)
		ATTACK:
			playerAttack(delta)

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
		animationState.travel("Run")
		vel = vel.move_toward(inputVector * MAX_SPEED, ACCEL * delta)
	else:
		animationState.travel("Idle")
		vel = vel.move_toward(Vector2.ZERO, FRICTION * delta)
	vel = move_and_slide(vel)
	
	if Input.is_action_just_pressed("player_attack"):
		state = ATTACK

func playerAttack(delta):
	vel = Vector2.ZERO
	animationState.travel("Attack")

func playerAttackFinished():
	state = MOVE
