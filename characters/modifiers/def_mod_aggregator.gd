extends RefCounted
class_name Def_mod_aggregator

var attk_aggregator = {}

#var dmg_type:int
#var damage:int
#var status_effects: Array

func _init(attk_info: Globals.Damage_info):
	attk_aggregator = {"dmg_type": attk_info.dmg_type, "status_effects":attk_info.status_effects, "damage": Mod_calculator.new(attk_info.damage)}

func modify_dmg(operation: int, modifier: float, dmg_type: Globals.Dmg_type):
	if dmg_type == null or dmg_type == attk_aggregator["dmg_type"]:
		attk_aggregator["damage"].add_modifier(operation, modifier)

func calculate() -> Globals.Damage_info:
	var ret_val: Globals.Damage_info
	var dmg = attk_aggregator["damage"].calculate()
	ret_val = Globals.Damage_info.new(attk_aggregator["dmg_type"], dmg, attk_aggregator["status_effects"])
	
	return ret_val
