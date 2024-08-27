extends Button

signal change_scene(level_name: String, data: Dictionary, scene_persist: bool)

@export var level_name: String
@export var data: Dictionary
@export var scene_persist: bool




func _on_pressed():
	change_scene.emit(level_name, data, scene_persist)
