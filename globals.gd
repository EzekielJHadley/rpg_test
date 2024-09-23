extends Node

enum Dmg_type {NONE, PHYSICAL, FIRE, ICE, LIGHT}

func string_to_Dmg_type(type_str: String) -> int:
	var ret: Dmg_type
	match type_str.to_lower():
		"physical":
			ret = Dmg_type.PHYSICAL
		"fire":
			ret = Dmg_type.FIRE
		"ice":
			ret = Dmg_type.ICE
		_:
			ret = Dmg_type.NONE
	
	return ret

class Damage_info:
	var dmg_type:int
	var damage:int
	var status_effects: Array
	
	func _init(type:int, dmg: int, status: Array) -> void:
		dmg_type = type
		damage = dmg
		status_effects = status
