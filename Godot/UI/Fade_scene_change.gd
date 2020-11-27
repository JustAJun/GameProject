extends ColorRect

onready var animation = $AnimationPlayer
var path_to_scene

signal fade_finished(value)

func play_anim():
	self.visible = true
	animation.play("Fade")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene(path_to_scene)
