extends RefCounted
class_name Magic

var name: String
var element: int
var base_stat: String
var effects: Array = []

var spell_scene: String
var spell_icon: String

func _init(spell_name: String, element_type: int, stat: String):
	name = spell_name
	element = element_type
	base_stat = stat

func get_scene() -> Resource:
	return load(spell_scene)

func get_spell_attack(stats: Stats) -> Globals.Damage_info:
	var damage: int = stats.get(base_stat)
	
	return Globals.Damage_info.new(element, damage, effects)
