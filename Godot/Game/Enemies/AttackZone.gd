extends Area2D


var can_attack = false
export var can_damage = false
func _on_AttackZone_area_entered(area):
	can_attack = true

func _on_AttackZone_area_exited(area):
	can_attack = false
