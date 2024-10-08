extends RefCounted
class_name Stats

signal health_update(new_hp)
signal mana_update(new_mp)

var character_name: String = ""

var HP_max: int
var HP: int:
	set(value):
		health_update.emit(value)
		HP = value
var MP_max: int
var MP: int:
	set(value):
		mana_update.emit(value)
		MP = value
var STR: int
var MGK: int

var spells_available: Dictionary = {}

var vulnerability: Array = []
var resistant: Array = []
var immune: Array = []

var SPRITE: String
var PORTRAIT: String

func _init(stats_file: String) -> void:
	load_from_json(stats_file)

func add_spell(new_spell: Magic):
	spells_available[new_spell.name] = new_spell
	
func get_spell_list() -> Dictionary:
	var spell_list: Dictionary = {}
	for key in spells_available.keys():
		spell_list[key] = (spells_available[key].cost < MP)
	return spell_list

func base_attk() -> Globals.Damage_info:
	var dmg = STR
	return Globals.Damage_info.new(Globals.Dmg_type.PHYSICAL, dmg, [])

func magic_attk(spell_name: String) -> Globals.Damage_info:
	var spell:Magic = spells_available.get(spell_name, Magic.new("null", Globals.Dmg_type.NONE, "STR", 0))
	MP -= spell.cost
	return spell.get_spell_attack(self)
	
func load_from_json(file_name: String):
	var json = JSON.new()
	var json_text = FileAccess.open(file_name, FileAccess.READ).get_as_text()
	var error = json.parse(json_text)
	assert(error == OK)
	var stats_value = json.data
	character_name = stats_value.get("character_name", "NaN")
	HP_max = stats_value.get("HP_max", 10)
	HP = HP_max
	MP_max = stats_value.get("MP_max", 0)
	MP = MP_max
	STR = stats_value.get("STR", 1)
	MGK = stats_value.get("MGK", 1)
	
	var vuln: Array = stats_value.get("vulnerability", [])
	for type in vuln:
		vulnerability.append(Globals.string_to_Dmg_type(type))
	var res: Array = stats_value.get("resistant", [])
	for type in res:
		resistant.append(Globals.string_to_Dmg_type(type))
	var immn: Array = stats_value.get("vulnerability", [])
	for type in immn:
		immune.append(Globals.string_to_Dmg_type(type))
	
	SPRITE = stats_value.get("SPRITE", "res://icon.svg")
	PORTRAIT = stats_value.get("PORTRAIT", "res://icon.svg")
