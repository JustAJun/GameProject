extends Node


var skills = {
	0: ["Blink", 0, 0, 0, ""], #--> slot_index: [skill_name, skill_damage, skill_cooldown, skill_range, skill_description]
	1: ["Fire Storm", 15, 10, 30, ""],
}

func _ready():
	skills[0][1] = JsonData.skills_data["Blink"]["SkillDamage"]
	skills[0][2] = JsonData.skills_data["Blink"]["SkillCooldown"]
	skills[0][3] = JsonData.skills_data["Blink"]["SkillRange"]
	skills[1][1] = JsonData.skills_data["Fire Storm"]["SkillDamage"]
	skills[1][2] = JsonData.skills_data["Fire Storm"]["SkillCooldown"]
	skills[1][3] = JsonData.skills_data["Fire Storm"]["SkillRange"]

