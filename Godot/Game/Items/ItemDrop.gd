extends KinematicBody2D

var item_name


# Called when the node enters the scene tree for the first time.
func _ready():
	var type = randi() % 5
	if type == 0:
		item_name = "Heal Potion"
	elif type == 1:
		item_name = "Coins"
	elif type == 2:
		item_name = "Iron Sword1"
	elif type == 3:
		item_name = "Iron Sword2"
	elif type == 4:
		item_name = "Mana Potion"
	$Sprite.texture = load("res://Pictures/Items/" + item_name + ".png")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
