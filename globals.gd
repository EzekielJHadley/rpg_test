extends Node

enum Dmg_type {NONE, PHYSICAL, FIRE, ICE, POISON, LIGHT}

enum Status_effect {NONE, POISON, BURN, STUN, CONFUSE, BLIND, SILENCE}

func string_to_Dmg_type(type_str: String) -> int:
	var ret: Dmg_type
	match type_str.to_lower():
		"physical":
			ret = Dmg_type.PHYSICAL
		"fire":
			ret = Dmg_type.FIRE
		"ice":
			ret = Dmg_type.ICE
		"poison":
			ret = Dmg_type.POISON
		_:
			ret = Dmg_type.NONE
	
	return ret

func Dmg_type_to_string(dmg_type: Dmg_type) ->  String:
	var ret: String
	match dmg_type:
		Dmg_type.PHYSICAL:
			ret = "physical"
		Dmg_type.FIRE:
			ret = "fire"
		Dmg_type.ICE:
			ret = "ice"
		Dmg_type.POISON:
			ret = "poison"
		_:
			ret = "None"
	
	return ret

class Damage_info:
	var dmg_type:int
	var damage:int
	var status_effects: Array
	
	func _init(type:int, dmg: int, status: Array) -> void:
		dmg_type = type
		damage = dmg
		status_effects = status
