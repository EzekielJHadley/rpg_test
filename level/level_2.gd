extends Node2D


signal change_level(level_name : String, data : Dictionary)

func set_up(date: Dictionary):
	if date.has("name"):
		$Label.text = date["name"]
	else:
		$Label.text = "NaN"

func go_back():
	change_level.emit("level_1", {}, false)
