extends RefCounted
class_name Magic

var name: String
var element: String
var base_stat: String
var effects: Array = []

var spell_scene: String
var spell_icon: String

func _init(spell_name: String, element_type: String, stat: String):
	name = spell_name
	element = element_type
	base_stat = stat

func get_scene() -> Resource:
	return load(spell_scene)

func get_spell_attack(stats: Stats) -> Dictionary:
	var damage: int = stats.get(base_stat)
	
	return {"type": element, "dmg":damage, "status":effects}
