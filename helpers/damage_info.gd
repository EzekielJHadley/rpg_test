extends RefCounted
class_name Damage_info

enum Dmg_type {NONE, PHYSICAL, FIRE, ICE, POISON, LIGHT}

enum Status_effect {NONE, POISON, BURN, STUN, CONFUSE, BLIND, SILENCE}

var element:int
var damage:int
var status_effects: Array

func _init(type:int, dmg: int, status: Array) -> void:
	element = type
	damage = dmg
	status_effects = status


static func Dmg_type_to_string(input_type: Dmg_type):
	return str(Dmg_type.keys()[input_type]).capitalize()
	
static func string_to_Dmg_type(type_str: String):
	return Dmg_type[type_str.to_upper().replace(" ", "_")]
