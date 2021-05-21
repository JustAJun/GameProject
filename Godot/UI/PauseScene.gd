extends Node2D

onready var fadeEffect = $FadeEffect
onready var playBtn = $VBoxContainer/PlayButton
onready var optionsBtn = $VBoxContainer/OptionsButton
onready var menuBtn = $VBoxContainer/MenuButton
onready var exitBtn = $VBoxContainer/ExitButton
onready var player = get_parent().get_parent().get_child(1).get_child(0)
 
var optionsScene = preload("res://UI/OptionsScreen.tscn")

var isPaused = false;
var isOptions = false;


func _ready():
	player.connect("player_death", self, "player_death_pause")
	$Label.text = "Paused"

func _process(delta):
	pass


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if !isOptions:
			isPaused = !isPaused
		if isPaused:
			playBtn.grab_focus()
			show()
			get_parent().get_child(3).visible = false
			get_tree().paused = true;
		elif !isPaused and !isOptions:
			hide();
			get_tree().paused = false;
			
func _on_PlayButton_pressed():
	isPaused = !isPaused
	if isPaused:
		show()
		get_tree().paused = true;
	elif !isPaused and !isOptions:
		hide();
		get_tree().paused = false;

func _on_OptionsButton_pressed():
	var optionsInstance = optionsScene.instance()
	optionsInstance.typeOfStart = 2;
#	optionsInstance
	hide()
	add_child(optionsInstance)
	isOptions = true


func _on_MenuButton_pressed():
	menuBtn.get_child(1).visible = false
	menuBtn.get_child(0).animation = "DarkSpirits"
	menuBtn.get_child(0).playing = true
	fadeEffect.play_anim()
	fadeEffect.path_to_scene = "res://UI/TitleScreen.tscn"
	isPaused = !isPaused
	get_tree().paused = false;

func _on_ExitButton_pressed():
	get_tree().quit()

func player_death_pause():
	$Label.text = "You died!"
	isPaused = true
	playBtn.grab_focus()
	show()
	get_parent().get_child(3).visible = false
	get_tree().paused = true;
