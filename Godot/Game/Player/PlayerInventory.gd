extends Node

signal active_item_updated

const SlotClass = preload("res://Game/Slot.gd")
const ItemClass = preload("res://Game/Items/Item.gd")

const NUM_INVENTORY_SLOTS = 35
const NUM_HOTBAR_SLOTS = 9

var inventory = {
	0: ["Heal Potion", 24, ""], #--> slot_index: [item_name, item_quantity, item_description]
	1: ["Mana Potion", 15, ""],
	10: ["Iron Sword2", 2, ""],
	34: ["Obsidian Shield", 1, ""]
}

var hotbar = {
	3: ["Coins", 90],
	1: ["Heal Potion", 1],
	2: ["Mana Potion", 15],
	0: ["Iron Sword1", 1],
}

var active_slot = 0

func _ready():
	pass
#	for item in inventory:
#		if item != null:
#			inventory[item][2] = JsonData.item_data[item.item_name]["Description"]


func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				item_quantity -= able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1])
	
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return

func update_slot_visual(index, item_name, item_quantity):
	var slot = get_tree().root.get_node("/root/Arena/UI/Inventory/GridContainer/Slot" + str(index+1))
	if slot.item != null:
		slot.item.set_item(item_name, item_quantity)
	else:
		slot.initialize_item(item_name, item_quantity)

func add_to_empty_slot(item: ItemClass, slot: SlotClass, is_hotbar: bool = false):
	if is_hotbar:
		hotbar[slot.index] = [item.item_name, item.item_quantity]
	else:
		inventory[slot.index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity: int, is_hotbar: bool = false):
	if is_hotbar:
		hotbar[slot.index][1] += quantity
	else:
		inventory[slot.index][1] += quantity

func remove_item(slot: SlotClass, is_hotbar: bool = false):
	if is_hotbar:
		hotbar.erase(slot.index) 
	else:
		inventory.erase(slot.index) 

func active_item_scroll_up():
	active_slot = (active_slot + 1) % 9
	emit_signal("active_item_updated")

func active_item_scroll_down():
	if active_slot == 0:
		active_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_slot -= 1
	emit_signal("active_item_updated")
