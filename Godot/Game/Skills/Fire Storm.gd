extends Node2D

onready var particles = $Particles2D
onready var skill_area = $Skill_Properties
onready var timer = $Timer
onready var particles_timer = $ParticlesTimer

var index = 1
var skill_name = "Fire Storm"
var skill_damage
var skill_cooldown
var skill_range

func _ready():
	if PlayerSkills.skills.has(index):
		skill_damage = PlayerSkills.skills[index][1]
		skill_cooldown = PlayerSkills.skills[index][2]
		skill_range = PlayerSkills.skills[index][3]
		initialize_skill()
		activate_skill()

func initialize_skill():
	skill_area.damage = skill_damage
	skill_area.skill_range = skill_range
	skill_area.init();

func activate_skill():
	particles.emitting = true
	timer.wait_time = 3
	timer.start()
#	skill_area.get_child(0).disabled = false
	skill_area.activate()
	

func _on_Timer_timeout():
	skill_area.stop()
	particles.emitting = false
	particles_timer.wait_time = 1
	particles_timer.start()

func _on_ParticlesTimer_timeout():
	queue_free()
