extends RefCounted
class_name Stats

var HP_max: int
var HP: int
var STR: int

func _init(hp:int, str:int) -> void:
	HP_max = hp
	HP = hp
	STR = str
	
func base_attk() -> Dictionary:
	var dmg = STR
	return {"type": "physical", "dmg":dmg, "status":null}
