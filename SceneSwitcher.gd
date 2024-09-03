extends Node

@onready var current_scene = $level_1
var old_scene = {}

func _ready():
	current_scene.connect("change_level", change_level)
	
	
func change_level(level_name: String, data: Dictionary, level_persist: bool):
	var next_level
	if level_name not in old_scene:
		var next_level_tscn: String = "res://level/" + level_name + ".tscn"
		
		next_level = load(next_level_tscn).instantiate()
	else:
		next_level = old_scene[level_name]
	next_level.set_up(data)
	if level_persist:
		old_scene[current_scene.name] = current_scene
	add_child(next_level)
	remove_child(current_scene)
	current_scene = next_level
	if not current_scene.is_connected("change_level", change_level):
		current_scene.connect("change_level", change_level)
	print(old_scene)
