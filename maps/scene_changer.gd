extends Node2D
class_name SceneChanger

signal change_scene(level_name: String, data: Dictionary, scene_persist: bool)

@export var level_name: String
@export var data: Dictionary
@export var scene_persist: bool

var is_shown: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func change(_trigger):
	if visible:
		print("this thing is visible")
		print(is_shown)
		change_scene.emit(level_name, data, scene_persist)
		queue_free() #sometimes a phantom instance persists, i don't know why....
