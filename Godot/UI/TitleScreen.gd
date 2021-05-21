extends Node

onready var playBtn = $MarginContainer/VBoxContainer/VBoxContainer/PlayButton
onready var optionsBtn = $MarginContainer/VBoxContainer/VBoxContainer/OptionsButton
onready var exitBtn = $MarginContainer/VBoxContainer/VBoxContainer/ExitButton
onready var fadeEffect = $FadeEffect
onready var audio = $AudioStreamPlayer

func _ready():
	playBtn.grab_focus()
	
func _physics_process(delta):
	pass
		
func _on_PlayButton_pressed():
	playBtn.get_child(1).visible = false
	playBtn.get_child(0).animation = "DarkSpirits"
	playBtn.get_child(0).playing = true
	fadeEffect.play_anim()
	fadeEffect.path_to_scene = "res://Game/Arena.tscn"

func _on_OptionsButton_pressed():
	optionsBtn.get_child(1).visible = false
	optionsBtn.get_child(0).animation = "DarkSpirits"
	optionsBtn.get_child(0).playing = true
	fadeEffect.play_anim()
	fadeEffect.path_to_scene = "res://UI/OptionsScreen.tscn"


func _on_ExitButton_pressed():
	exitBtn.get_child(1).visible = false
	exitBtn.get_child(0).animation = "DarkSpirits"
	exitBtn.get_child(0).playing = true
	get_tree().quit()
