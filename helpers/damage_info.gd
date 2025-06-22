extends RefCounted
class_name Damage_info

enum Dmg_type {NONE, PHYSICAL, FIRE, ICE, POISON, LIGHT}

enum Range_type {NONE, CLOSE, MID, FAR}
# Made ALL special (-1)
# 1 should be default, for more an integer will suffice
enum target_type {ALL, NONE = 0, SINGLE, DOUBLE, TRIPLE} 

enum Status_effect {NONE, POISON, BURN, STUN, CONFUSE, BLIND, SILENCE}

var element:int
var damage:int
var status_effects: Array

func _init(type:int, dmg: int, status: Array) -> void:
	element = type
	damage = dmg
	status_effects = status

static func string_to_Dmg_type(type_str: String) -> int:
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

static func Dmg_type_to_string(element_val: Dmg_type) ->  String:
	var ret: String
	match element_val:
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




