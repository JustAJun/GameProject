extends Control

var HP = 10 setget set_hp
var max_HP = 10 setget set_max_hp
var level = 1 setget set_level
var percent = 1
onready var hp_bar = $HP_Full
onready var label = $Label
onready var levelUI = $LevelUI

func set_level(value):
	levelUI.text = "Lvl " + str(value)

func set_hp(value):
	HP = clamp(value, 0, max_HP)
	hp_bar.rect_size.x = 180 - (max_HP - HP) * percent
	label.text = str(HP)
	
func set_max_hp(value):
	max_HP = max(value, 1)

	percent = float(150.0)/float(max_HP)
	hp_bar.rect_size.x = 180 - (max_HP - HP) * percent
	label.text = "HP = " + str(HP)
	
func _ready():
	self.max_HP = PlayerStats.max_health
	self.HP = PlayerStats.health
	self.level = PlayerStats.level
	percent = float(150.0)/float(max_HP)
	PlayerStats.connect("max_health_changed", self, "set_max_hp")
	PlayerStats.connect("healh_changed", self, "set_hp")
	PlayerStats.connect("level_changed", self, "set_level")
	
	
