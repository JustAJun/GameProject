extends Panel

onready var timer = $Timer

var default_tex = preload("res://Pictures/Stuff/Slot3.png")
var default_style: StyleBoxTexture = null
var selected_tex = preload("res://Pictures/Stuff/ActiveSlot.png")
var selected_style: StyleBoxTexture = null

var skill_name
var skill_damage
var skill_cooldown
var skill_range
var index
var isAvailable = true


func _ready():
	selected_style = StyleBoxTexture.new()
	selected_style.texture = selected_tex

func _on_SkillSlot_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if PlayerSkills.skills.has(index) and index != 0 and isAvailable:
#				var skill_scene = load("res://Game/Skills/" + skill_name + ".tscn")
#				var skill_instance = skill_scene.instance()
#				skill_instance.position = Vector2(0,0)
#				get_tree().root.get_node("/root/Arena/YSort/Player").add_child(skill_instance)
#				get_tree().root.get_node("/root/Arena/YSort/Player").move_child(skill_instance,0)
#				if skill_cooldown > 0:
#					isAvailable = false
#					timer.wait_time = skill_cooldown
#					timer.start()
				activate_skill()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			if PlayerSkills.skills.has(index) and index == 0 and isAvailable:
				activate_skill()
	if event is InputEventKey:
		if event.scancode == KEY_1 and event.pressed:
			if PlayerSkills.skills.has(index) and index == 0 and isAvailable:
#				var skill_scene = load("res://Game/Skills/" + skill_name + ".tscn")
#				var skill_instance = skill_scene.instance()
#				skill_instance.position = Vector2(0,0)
#				get_tree().root.get_node("/root/Arena/YSort/Player").add_child(skill_instance)
#				get_tree().root.get_node("/root/Arena/YSort/Player").move_child(skill_instance,0)
#				if skill_cooldown > 0:
#					isAvailable = false
#					timer.wait_time = skill_cooldown
#					timer.start()
				activate_skill()
		elif event.scancode == KEY_2 and event.pressed:
			if PlayerSkills.skills.has(index) and index == 1 and isAvailable:
				activate_skill()

func initialize_slot():
	if index == 0:
		set('custom_styles/panel', selected_style)
	if PlayerSkills.skills.has(index):
		skill_name = PlayerSkills.skills[index][0]
		skill_cooldown = PlayerSkills.skills[index][2]

func activate_skill():
	var skill_scene = load("res://Game/Skills/" + skill_name + ".tscn")
	var skill_instance = skill_scene.instance()
	skill_instance.position = Vector2(0,0)
	get_tree().root.get_node("/root/Arena/YSort/Player").add_child(skill_instance)
	get_tree().root.get_node("/root/Arena/YSort/Player").move_child(skill_instance,0)
	if skill_cooldown > 0:
		set_modulate("77777777")
		isAvailable = false
		timer.wait_time = skill_cooldown
		timer.start()

func _on_Timer_timeout():
	isAvailable = true
	set_modulate("ffffffff")
	
