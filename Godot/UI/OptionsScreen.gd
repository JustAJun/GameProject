extends Node

onready var backBtn = $MarginContainer/Sprite/VBoxContainer/VBoxContainer2/BackToMenu
onready var fadeEffect = $FadeEffect
onready var audio = $AudioStreamPlayer

onready var screenBtn = $MarginContainer/Sprite/VBoxContainer/VBoxContainer/HBoxContainer/ScreenBox

func _ready():
	OS.request_attention()
	if OS.window_fullscreen:
		screenBtn.pressed = OS.window_fullscreen

func _physics_process(delta):
	if backBtn.is_hovered():
		backBtn.grab_focus()

	if backBtn.has_focus():
		backBtn.get_child(0).playing = true
		backBtn.get_child(0).visible = true
	else: 
		backBtn.get_child(0).visible = false 
		backBtn.get_child(0).playing = false

func _on_BackToMenu_pressed():
	backBtn.get_child(1).visible = false
	backBtn.get_child(0).animation = "DarkSpirits"
	backBtn.get_child(0).playing = true
	fadeEffect.play_anim()
	audio.play()
	fadeEffect.path_to_scene = "res://UI/TitleScreen.tscn"

func _on_ScreenBox_toggled(button_pressed):
	if screenBtn.pressed != OS.window_fullscreen:
		OS.window_fullscreen = !OS.window_fullscreen
