extends RefCounted
class_name Dmg_mod_aggregator

var attk_aggregator = {}

#var dmg_type:int
#var damage:int
#var status_effects: Array

func _init(attk_info: Damage_info):
	attk_aggregator = {"dmg_type": attk_info.element, "status_effects":attk_info.status_effects, "damage": Mod_calculator.new(attk_info.damage)}

func modify_attk(operation: int, modifier: float, add_effects: Array, dmg_type: Damage_info.Dmg_type):
	attk_aggregator["damage"].add_modifier(operation, modifier)
	if dmg_type != null:
		attk_aggregator["dmg_type"] = dmg_type
	if add_effects != null:
		attk_aggregator["status_effects"].append_array(add_effects)

func calculate() -> Damage_info:
	var ret_val: Damage_info
	var dmg = attk_aggregator["damage"].calculate()
	ret_val = Damage_info.new(attk_aggregator["dmg_type"], dmg, attk_aggregator["status_effects"])
	
	return ret_val
