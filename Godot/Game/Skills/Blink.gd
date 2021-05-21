extends Node2D

onready var particles = $Particles2D
onready var timer = $Timer


func _ready():
	var player = get_tree().root.get_node("/root/Arena/YSort/Player")
	timer.start()
	particles.emitting = true
	player.position = get_global_mouse_position()
	



func _on_Timer_timeout():
	queue_free()
