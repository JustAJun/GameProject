extends Area2D


func _ready():
	pass # Replace with function body.


func _on_PickUpZone_body_entered(body):
	pick_up_item(body)

func pick_up_item(body):
	PlayerInventory.add_item(body.item_name, 1)
	body.queue_free()
