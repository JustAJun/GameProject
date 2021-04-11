extends Node2D

func _ready():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = false;
