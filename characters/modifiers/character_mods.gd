extends RefCounted
class_name Char_mods

var passive_mods: Array = []
var status_effects: Dictionary = {}

func _init():
	for effect in Globals.Status_effect.keys():
		status_effects.get_or_add(effect)

func add_mod(mod: Modifiers):
	if mod is Effect:
		status_effects[mod.effect_type] = mod
		mod.connect("end_effect", rm_mod.bind(mod))
	else:
		passive_mods.append(mod)


func rm_mod(mod: Modifiers):
	if mod is Effect:
		mod.disconnect("end_effect", rm_mod.bind(mod))
		status_effects[mod.effect_type] = null
	else:
		var index = passive_mods.find(mod)
		passive_mods.remove_at(index)


func get_mods():
	var ret: Array = passive_mods.duplicate()
	for effect_name in status_effects:
		if status_effects[effect_name] != null:
			ret.append(status_effects[effect_name])

	return ret


func cure(effect_type: String):
	effect_type = effect_type.to_upper()
	if effect_type in status_effects and status_effects[effect_type] != null:
		status_effects[effect_type].remove()
