extends RefCounted
class_name Stats

var character_name: String = ""

var HP_max: int
var HP: int
var STR: int

var SPRITE: String = "res://icon.svg"
var PORTRAIT: String = "res://icon.svg"

func _init(name: String, hp:int, strn:int, sprite:String) -> void:
	character_name = name
	HP_max = hp
	HP = hp
	STR = strn
	
	SPRITE = sprite
	PORTRAIT = sprite
	
func base_attk() -> Dictionary:
	var dmg = STR
	return {"type": "physical", "dmg":dmg, "status":null}
