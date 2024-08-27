extends Node2D
class_name Level_root

signal change_level(level_name : String, data : Dictionary, level_persist: bool)

func set_up(_data: Dictionary):
	pass
	
func change_scene(scene_name: String, data : Dictionary, scene_persist: bool):
	change_level.emit(scene_name, data, scene_persist)
