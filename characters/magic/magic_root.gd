extends RefCounted
class_name Magic

var name: String
var element: int
var base_stat: String
var effects: Array = []
var cost: int

var spell_scene: String
var spell_icon: String

func _init(spell_name: String, element_type: int, stat: String, mp_cost: int):
	name = spell_name
	element = element_type
	base_stat = stat
	cost = mp_cost

func get_scene() -> Resource:
	return load(spell_scene)

func get_spell_attack(stats: Stats) -> Damage_info:
	var damage: int = stats.get(base_stat)
	
	return Damage_info.new(element, damage, effects)
