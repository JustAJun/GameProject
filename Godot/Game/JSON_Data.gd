extends Node

var item_data: Dictionary
var skills_data: Dictionary


func _ready():
	item_data = loadData("res://Data/ItemData.json")
	skills_data = loadData("res://Data/SkillData.json")

func loadData(file_path):
	var json_data
	var file = File.new()
	
	file.open(file_path, File.READ)
	json_data = JSON.parse(file.get_as_text())
	file.close()
	return json_data.result
