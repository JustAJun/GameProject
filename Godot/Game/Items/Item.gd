extends Node2D

var item_name
var item_quantity
var item_description

func _ready():
	pass
#	var rand_val = randi() % 2
#	if rand_val == 0:
#		item_name = "Coins"
#	else:
#		item_name = "Heal Potion"
#
#	$TextureRect.texture = load("res://Pictures/Items/" + item_name + ".png")
#	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
#	item_quantity = randi() % stack_size + 1
#
#	if stack_size == 1:
#		$Label.visible = false
#	else:
#		$Label.text = String(item_quantity)

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load("res://Pictures/Items/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)


func addQuantity(amount):
	item_quantity += amount
	$Label.text = String(item_quantity)

func removeQuantity(amount):
	item_quantity -= amount
	$Label.text = String(item_quantity)

