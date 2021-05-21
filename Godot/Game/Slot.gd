extends Panel

onready var inventoryNode = find_parent("UI")

var default_tex = preload("res://Pictures/Stuff/Slot3.png")
var empty_tex = preload("res://Pictures/Stuff/Slot2.png")
var selected_tex = preload("res://Pictures/Stuff/ActiveSlot.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null


var ItemClass = preload("res://Game/Items/Item.tscn")
var item = null
var index
var slot_type

enum SlotType {
	HOTBAR = 0,
	INVENTORY
}

func _ready():
	default_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style = StyleBoxTexture.new()
	empty_style.texture = empty_tex
	selected_style = StyleBoxTexture.new()
	selected_style.texture = selected_tex
	
#	if randi() % 2 == 0:
#		item = ItemClass.instance()
#		add_child(item)
	refreshStyle()
	
func refreshStyle():
	if slot_type == SlotType.HOTBAR and PlayerInventory.active_slot == index:
		set('custom_styles/panel', selected_style)
	elif item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)
	

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	inventoryNode.remove_child(item)
	add_child(item)
	refreshStyle()

func pickFromSlot():
	remove_child(item)
	inventoryNode.add_child(item)
	item = null
	refreshStyle()

func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refreshStyle()


func _on_Slot_mouse_entered():
#	print(index)
	if PlayerInventory.inventory.has(index):	
		var item_description = JsonData.item_data[PlayerInventory.inventory[index][0]]["Description"]
		get_parent().get_parent().get_child(2).get_child(0).text = item_description
		get_parent().get_parent().get_child(2)._set_global_position(get_global_position())
		get_parent().get_parent().get_child(2).rect_position.x += 35
		get_parent().get_parent().get_child(2).visible = true
		


func _on_Slot_mouse_exited():
	get_parent().get_parent().get_child(2).visible = false



