extends CanvasLayer

var holding_item = null

func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()
