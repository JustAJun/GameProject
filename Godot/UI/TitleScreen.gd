extends Node

onready var playBtn = $MarginContainer/VBoxContainer/VBoxContainer/PlayButton
onready var optionsBtn = $MarginContainer/VBoxContainer/VBoxContainer/OptionsButton
onready var exitBtn = $MarginContainer/VBoxContainer/VBoxContainer/ExitButton
onready var fadeEffect = $FadeEffect
onready var audio = $AudioStreamPlayer

func _ready():
	playBtn.grab_focus()
	playBtn.get_child(0).animation = "CandlesBurning"
	optionsBtn.get_child(0).animation = "CandlesBurning"
	exitBtn.get_child(0).animation = "CandlesBurning"
	
func _physics_process(delta):
	if playBtn.is_hovered():
		playBtn.grab_focus()
	if optionsBtn.is_hovered():
		optionsBtn.grab_focus()
	if exitBtn.is_hovered():
		exitBtn.grab_focus()
	
	if playBtn.has_focus():
		playBtn.get_child(0).playing = true
		playBtn.get_child(0).visible = true
	else: 
		playBtn.get_child(0).visible = false 
		playBtn.get_child(0).playing = false

	if optionsBtn.has_focus():
		optionsBtn.get_child(0).playing = true
		optionsBtn.get_child(0).visible = true
	else: 
		optionsBtn.get_child(0).visible = false 
		optionsBtn.get_child(0).playing = false
		
	if exitBtn.has_focus():
		exitBtn.get_child(0).playing = true
		exitBtn.get_child(0).visible = true
	else: 
		exitBtn.get_child(0).visible = false 
		exitBtn.get_child(0).playing = false
		
func _on_PlayButton_pressed():
	playBtn.get_child(1).visible = false
	playBtn.get_child(0).animation = "DarkSpirits"
	playBtn.get_child(0).playing = true
	fadeEffect.play_anim()
	fadeEffect.path_to_scene = "res://Game/Arena.tscn"
	audio.play()

func _on_OptionsButton_pressed():
	optionsBtn.get_child(1).visible = false
	optionsBtn.get_child(0).animation = "DarkSpirits"
	optionsBtn.get_child(0).playing = true
	audio.play()
	fadeEffect.play_anim()
	fadeEffect.path_to_scene = "res://UI/OptionsScreen.tscn"

func _on_ExitButton_pressed():
	exitBtn.get_child(1).visible = false
	exitBtn.get_child(0).animation = "DarkSpirits"
	exitBtn.get_child(0).playing = true
	audio.play()
	get_tree().quit()

