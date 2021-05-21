extends Node2D

export(int) var SPAWN_FREQUENCY = 10
const NOT_SPAWN_RANGE_X = 1550
const NOT_SPAWN_RANGE_Y = 910
const SPAWN_RANGE = 200

onready var map = $YSort
onready var acolyte = preload("res://Game/Enemies/Acolyte.tscn")
onready var wolf = preload("res://Game/Enemies/Wolf.tscn")
onready var item = preload("res://Game/Items/ItemDrop.tscn")
onready var player = $YSort/Player
onready var spawnTimer = $SpawnTimer
onready var wave = $UI/Wave
onready var pauseScene = $UI/PauseScene

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
#	OS.window_fullscreen = true
	pauseScene.hide()
#	player.connect("player_death", self, "player_death_pause")
	if current_wave_number * 2 + 5 <= player.stats.level:
		SPAWN_FREQUENCY = 10
		
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		set_process_input(false)
	if Input.is_action_just_pressed("Inventory"):
		$UI/Inventory.visible = !$UI/Inventory.visible
		if !$UI/Inventory.visible:
			$UI/Inventory/Description.visible = false
		$UI/Inventory.initialize_inventory()

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
	
func add_item():
	choose_spawn_place()
	var item_instance =item.instance()
	item_instance.scale.x = 3
	item_instance.scale.y = 3
	item_instance.position.x = spawn_x
	item_instance.position.y = spawn_y
	map.add_child(item_instance)

func _on_SpawnTimer_timeout():
	wave.text = "Current wave: " + str(current_wave_number)
	add_item()
	add_item()
	add_item()
	for _i in range(10):
		add_enemy()
	if current_wave_number * 2 + 10 > player.stats.level:
		SPAWN_FREQUENCY = 3
	spawnTimer.start(SPAWN_FREQUENCY)
	current_wave_number += 1

func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
