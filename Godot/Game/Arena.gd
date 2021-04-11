extends Node2D

export(int) var SPAWN_FREQUENCY = 10
const NOT_SPAWN_RANGE_X = 1550
const NOT_SPAWN_RANGE_Y = 910
const SPAWN_RANGE = 200

onready var map = $YSort
onready var acolyte = preload("res://Game/Enemies/Acolyte.tscn")
onready var wolf = preload("res://Game/Enemies/Wolf.tscn")
onready var pauseScene = preload("res://UI/PauseScene.tscn")
onready var player = $YSort/Player
onready var spawnTimer = $SpawnTimer
onready var wave = $CanvasLayer/Wave

var isPaused = false; 
var spawn_place 
var spawn_x
var spawn_y
var current_wave_number = 1
var type_of_enemy: int = 0

enum {
	TOP,
	LEFT,
	BOTTOM,
	RIGHT
}

enum {
	ACOLYTE,
	WOLF,
	TROLL
}

func _ready():
	if current_wave_number * 2 + 5 <= player.stats.level:
		SPAWN_FREQUENCY = 10
		
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		var paused_instance = pauseScene.instance()
		paused_instance.position.x = 0
		paused_instance.position.y = 0
		map.add_child(paused_instance)
		get_tree().paused = true;
		

#		get_tree().change_scene("res://UI/TitleScreen.tscn")
		
func choose_spawn_place():
	var state_rand = [TOP, BOTTOM]
	spawn_x = rand_range(player.global_position.x - NOT_SPAWN_RANGE_X - SPAWN_RANGE, player.global_position.x + NOT_SPAWN_RANGE_X + SPAWN_RANGE)
	if spawn_x < player.global_position.x - NOT_SPAWN_RANGE_X:
		spawn_place = LEFT
	elif spawn_x > player.global_position.x + NOT_SPAWN_RANGE_X:
		spawn_place = RIGHT
	else:
		state_rand.shuffle()
		spawn_place = state_rand.pop_front()
	
	match spawn_place:
		LEFT,RIGHT:
			spawn_y = rand_range(player.global_position.y - NOT_SPAWN_RANGE_Y - SPAWN_RANGE, player.global_position.y + NOT_SPAWN_RANGE_Y + SPAWN_RANGE)
		
		TOP:
			spawn_y = rand_range(player.global_position.y - NOT_SPAWN_RANGE_Y - SPAWN_RANGE, player.global_position.y - NOT_SPAWN_RANGE_Y)
		
		BOTTOM:
					spawn_y = rand_range(player.global_position.y + NOT_SPAWN_RANGE_Y, player.global_position.y + NOT_SPAWN_RANGE_Y + SPAWN_RANGE)

func choose_enemy_type():
	type_of_enemy = rand_range(0,2)
	print(type_of_enemy)
	match type_of_enemy:
		ACOLYTE:
			return acolyte
		
		WOLF:
			return wolf
		
		TROLL:
			return acolyte

func choose_enemy_level():
	var lvl: int = rand_range(current_wave_number*2-1,current_wave_number*2+2)
	return lvl

func add_enemy():
	choose_spawn_place()
	var enemy_instance = 	choose_enemy_type().instance()
	var enemy_stats = enemy_instance.get_node("Stats")
	enemy_stats.level = choose_enemy_level()
	enemy_instance.position.x = spawn_x
	enemy_instance.position.y = spawn_y
	map.add_child(enemy_instance)
	

func _on_SpawnTimer_timeout():
	wave.text = "Current wave: " + str(current_wave_number)
	for _i in range(1):
		add_enemy()
	if current_wave_number * 2 + 10 > player.stats.level:
		SPAWN_FREQUENCY = 3
	spawnTimer.start(SPAWN_FREQUENCY)
	current_wave_number += 1
	
	
