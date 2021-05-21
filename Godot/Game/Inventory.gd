extends Node2D

const SlotClass = preload("res://Game/Slot.gd")
onready var inventory_slots = $GridContainer

func _ready():
	var slots = inventory_slots.get_children()
	for i in range (slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].index = i
		slots[i].slot_type = SlotClass.SlotType.INVENTORY
	initialize_inventory()
	

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range (slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])


func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if find_parent("UI").holding_item != null:
				if !slot.item:
					PlayerInventory.add_to_empty_slot(find_parent("UI").holding_item, slot)
					slot.putIntoSlot(find_parent("UI").holding_item)
					find_parent("UI").holding_item = null
				else:
					if find_parent("UI").holding_item.item_name != slot.item.item_name:
						PlayerInventory.remove_item(slot)
						PlayerInventory.add_to_empty_slot(find_parent("UI").holding_item, slot)
						var temp_item = slot.item
						slot.pickFromSlot()
						temp_item.global_position = event.global_position
						slot.putIntoSlot(find_parent("UI").holding_item)
						find_parent("UI").holding_item = temp_item
					else:
						var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
						var able_to_add = stack_size - slot.item.item_quantity
						if able_to_add >= find_parent("UI").holding_item.item_quantity:
							PlayerInventory.add_item_quantity(slot, find_parent("UI").holding_item.item_quantity)
							slot.item.addQuantity(find_parent("UI").holding_item.item_quantity)
							find_parent("UI").holding_item.queue_free()
							find_parent("UI").holding_item = null
						else:
							PlayerInventory.add_item_quantity(slot, able_to_add)
							slot.item.addQuantity(able_to_add)
							find_parent("UI").holding_item.removeQuantity(able_to_add)
					
			elif slot.item:
				PlayerInventory.remove_item(slot)
				find_parent("UI").holding_item = slot.item
				slot.pickFromSlot()
				find_parent("UI").holding_item.global_position = get_global_mouse_position()



func _input(event):
	if find_parent("UI").holding_item:
		find_parent("UI").holding_item.global_position = get_global_mouse_position()


