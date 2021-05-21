extends Node2D

const SlotClass = preload("res://Game/Slot.gd")

onready var hotbar = $HotbarSlots
onready var slots = hotbar.get_children()

func _ready():
	PlayerInventory.connect("active_item_updated", self, "update_acive_item_label")
	for i in range (slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		PlayerInventory.connect("active_item_updated", slots[i], "refreshStyle")
		slots[i].index = i
		slots[i].slot_type = SlotClass.SlotType.HOTBAR
	initialize_hotbar()
	update_acive_item_label()

func initialize_hotbar():
	for i in range (slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if find_parent("UI").holding_item != null:
				if !slot.item:
					PlayerInventory.add_to_empty_slot(find_parent("UI").holding_item, slot, true)
					slot.putIntoSlot(find_parent("UI").holding_item)
					find_parent("UI").holding_item = null
				else:
					if find_parent("UI").holding_item.item_name != slot.item.item_name:
#						PlayerInventory.remove_item(slot)
						PlayerInventory.add_to_empty_slot(find_parent("UI").holding_item, slot, true)
						var temp_item = slot.item
						slot.pickFromSlot()
						temp_item.global_position = event.global_position
						slot.putIntoSlot(find_parent("UI").holding_item)
						find_parent("UI").holding_item = temp_item
					else:
						var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
						var able_to_add = stack_size - slot.item.item_quantity
						if able_to_add >= find_parent("UI").holding_item.item_quantity:
							PlayerInventory.add_item_quantity(slot, find_parent("UI").holding_item.item_quantity, true)
							slot.item.addQuantity(find_parent("UI").holding_item.item_quantity)
							find_parent("UI").holding_item.queue_free()
							find_parent("UI").holding_item = null
						else:
							PlayerInventory.add_item_quantity(slot, able_to_add, true)
							slot.item.addQuantity(able_to_add)
							find_parent("UI").holding_item.removeQuantity(able_to_add)
					
			elif slot.item:
				PlayerInventory.remove_item(slot, true)
				find_parent("UI").holding_item = slot.item
				slot.pickFromSlot()
				find_parent("UI").holding_item.global_position = get_global_mouse_position()
			update_acive_item_label()

func update_acive_item_label():
	if slots[PlayerInventory.active_slot].item != null:
		$ActiveItem.text = PlayerInventory.hotbar[PlayerInventory.active_slot][0]
	else:
		$ActiveItem.text = ""
