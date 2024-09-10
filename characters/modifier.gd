extends RefCounted
class_name Modifiers

signal mod_animation_start

#contains dicts with "stat to modify" "how to modify value" and "how much to modify it"
var stat_mods: Array = []
#contains dicts with "attk type" "how to modify dmg" and "how much to modify it"
var attk_mods: Array = []
#contains dicts with "element" "how to modify dmg" and "how much to modify it"
var magic_mods: Array = []
#cotnains "element" "how to modify dmg" and "how much to modify it"
var def_mods: Array = []


func on_turn_start(character: Character):
	pass

func stats_modifier(calc: Stat_calculator):
	for mod in stat_mods:
		calc.modify_stat(mod.get("stat", "NaN"), mod.get("operator", Mod_calculator.NONE), mod.get("modifier", 0))
#operation: int, modifier: float, add_effects = null, dmg_type = null
func dmg_modifier(calc: Attk_calculator):
	for mod in attk_mods:
		calc.modify_stat(mod.get("operator", Mod_calculator.NONE), mod.get("modifier", 0), mod.get("add_effect", null), mod.get("dmg_type", null))

func magic_modifiers(calc):
	for mod in magic_mods:
		calc.modify_stat(mod.get("operator", Mod_calculator.NONE), mod.get("modifier", 0), mod.get("add_effect", null), mod.get("dmg_type", null))

func def_modifier(calc):
	for mod in def_mods:
		calc.modify_stat(mod.get("operator", Mod_calculator.NONE), mod.get("modifier", 0), mod.get("add_effect", null), mod.get("dmg_type", null))
