extends Node

export(int) var level = 1 setget set_level
export(int) var default_xp = 1 
var xp: int = 0 setget set_xp
export(int) var strength = 2 setget set_strength
export(int) var dexterity = 1
export(int) var intelligence = 1
export(int) var feature_points = 10

export(int) var origin_health = 5
export(int) var max_health: int = 5 + strength*0.5 setget set_max_health
var health = max_health setget set_health

export(int) var origin_damage = 1
export(int) var damage: int = 0 setget set_damage

signal level_changed(value)
signal no_health
signal max_health_changed(value)
signal healh_changed(value)
signal damage_changed(value)

func set_level(value):
	var level_change = value - level
	level = value
	self.strength += level_change*2
	self.dexterity += level_change*1
	self.health = self.max_health
	emit_signal("level_changed", level)
	
func set_xp(value):
	xp = value
	if xp >= 20:
		self.level += xp/20
		xp = xp % 20

func set_strength(value):
	var strength_change = value - strength
	strength = value
	self.damage = origin_damage + strength/5
	if strength_change == -1 and strength % 2 != 0:
		self.max_health -= 1
	elif strength_change == 1 and strength % 2 == 0:
		self.max_health += 1
	elif strength_change == -1 or strength_change == 1:
		pass
	else: 
		self.max_health = origin_health + strength*0.5

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
	
func set_health(value):
	health = value
	emit_signal("healh_changed", health)
	if value <= 0:
		emit_signal("no_health")
		
func set_damage(value):
	damage = value
	emit_signal("damage_changed", damage)
	
func _ready():
	self.health = max_health
	

