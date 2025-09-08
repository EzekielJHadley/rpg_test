extends SceneChanger
class_name SceneChangerArea


func _ready():
	var test = data.duplicate()
	data = test
	data["door"] = name
