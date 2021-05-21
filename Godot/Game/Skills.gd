extends Node2D

const SlotClass = preload("res://Game/SkillSlot.gd")
onready var skill_slots = $SkillSlots


func _ready():
	var slots = skill_slots.get_children()
	for i in range (slots.size()):
		slots[i].index = i
		slots[i].initialize_slot()
