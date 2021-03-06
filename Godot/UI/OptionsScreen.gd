extends Node

onready var backBtn = $MarginContainer/Sprite/VBoxContainer/VBoxContainer2/BackToMenu
onready var fadeEffect = $FadeEffect
onready var audio = $AudioStreamPlayer
onready var screenBtn = $MarginContainer/Sprite/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/ScreenBox

var typeOfStart = 1;

func _ready():
	if typeOfStart != 1:
		get_child(0).hide()
		$MarginContainer/Sprite.set_modulate("f4ffffff")
		$MarginContainer/Sprite.z_index = 1
	OS.request_attention()
	if OS.window_fullscreen:
		screenBtn.pressed = OS.window_fullscreen

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if typeOfStart == 1:
			backBtn.get_child(1).visible = false
			backBtn.get_child(0).animation = "DarkSpirits"
			backBtn.get_child(0).playing = true
			fadeEffect.play_anim()
			fadeEffect.path_to_scene = "res://UI/TitleScreen.tscn"
		else:
			get_parent().isOptions = false;
			get_parent().show()
			typeOfStart = 1;
			queue_free()

	if backBtn.is_hovered():
		backBtn.grab_focus()

	if backBtn.has_focus():
		backBtn.get_child(0).playing = true
		backBtn.get_child(0).visible = true
	else: 
		backBtn.get_child(0).visible = false 
		backBtn.get_child(0).playing = false

func _on_BackToMenu_pressed():
	if typeOfStart == 1:
		backBtn.get_child(1).visible = false
		backBtn.get_child(0).animation = "DarkSpirits"
		backBtn.get_child(0).playing = true
		fadeEffect.play_anim()
		fadeEffect.path_to_scene = "res://UI/TitleScreen.tscn"
	else:
		get_parent().isOptions = false;
		get_parent().show()
		typeOfStart = 1;
		queue_free()
		

func _on_ScreenBox_toggled(button_pressed):
	if screenBtn.pressed != OS.window_fullscreen:
		OS.window_fullscreen = !OS.window_fullscreen
