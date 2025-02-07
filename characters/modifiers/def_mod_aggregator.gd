extends RefCounted
class_name Def_mod_aggregator

var attk_aggregator = {}

#var element:int
#var damage:int
#var status_effects: Array

func _init(attk_info: Damage_info):
	attk_aggregator = {"element": attk_info.element, "status_effects":attk_info.status_effects, "damage": Mod_calculator.new(attk_info.damage)}

func modify_dmg(operation: int, modifier: float, element: Damage_info.Dmg_type):
	if element == null or element == attk_aggregator["element"]:
		attk_aggregator["damage"].add_modifier(operation, modifier)

func calculate() -> Damage_info:
	var ret_val: Damage_info
	var dmg = attk_aggregator["damage"].calculate()
	ret_val = Damage_info.new(attk_aggregator["element"], dmg, attk_aggregator["status_effects"])
	
	return ret_val
