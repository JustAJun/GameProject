extends Node

onready var playBtn = $MarginContainer/VBoxContainer/VBoxContainer/PlayButton
onready var exitBtn = $MarginContainer/VBoxContainer/VBoxContainer/ExitButton
onready var fadeEffect = $FadeEffect
onready var audio = $AudioStreamPlayer

func _ready():
	playBtn.grab_focus()
	
func _physics_process(delta):
	if playBtn.is_hovered():
		playBtn.grab_focus()
	if exitBtn.is_hovered():
		exitBtn.grab_focus()


func _on_PlayButton_pressed():
	fadeEffect.play_anim()
	fadeEffect.path_to_scene = "res://Game/Arena.tscn"
	audio.play()

func _on_OptionsButton_pressed():
	audio.play()
	fadeEffect.play_anim()
	fadeEffect.path_to_scene = "res://Game/Arena.tscn"

func _on_ExitButton_pressed():
	audio.play()
	get_tree().quit()
