extends Node

enum Dmg_type {NONE, PHYSICAL, FIRE, ICE}

class Damage_info:
	var dmg_type:int
	var damage:int
	var status_effects: Array
	
	func _init(type:int, dmg: int, status: Array) -> void:
		dmg_type = type
		damage = dmg
		status_effects = status
