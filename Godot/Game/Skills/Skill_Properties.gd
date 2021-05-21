extends "res://Overlap/Hitbox.gd"

onready var skill_properties = $CollisionShape2D
onready var timer = $Timer

export var skill_range = 1
var knockbackVector = Vector2.ZERO

func _ready():
	pass
	#TODO: All the priperties of the area should be places here 
#	print(skill_range)
#	skill_properties.shape.set("radius", skill_range)

func init():
	skill_properties.shape.set("radius", skill_range)
	
func activate():
	$CollisionShape2D.disabled = false
	timer.start()

func stop():
	timer.stop()
	$CollisionShape2D.disabled = true

func _on_Timer_timeout():
	$CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = false
	timer.start()
