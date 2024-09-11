extends RefCounted
class_name Stats

signal health_update(new_hp)
signal mana_update(new_mp)

var character_name: String = ""

var HP_base: int
var MP_base: int
var STR_base: int
var MGK_base: int

var HP_max: int = 0
var HP: int = 0:
	set(value):
		health_update.emit(value)
		HP = value
var MP_max: int = 0
var MP: int = 0:
	set(value):
		mana_update.emit(value)
		MP = value
var STR: int
var MGK: int

var spells_available: Dictionary = {}
var passive_skills: Array = []

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
	
func calculate_stats():
	var calculator = Stat_calculator.new(self)
	for passive in passive_skills:
		pass
	var updated_stats = calculator.calculate()
	#now assigned the calculated skills to the new skills
	#for HP and MP, increase by how much max increases
	#they don't reset when their maxes increase
	var delta_hp = updated_stats.get("HP_max", HP_base) - HP_max
	HP_max = updated_stats.get("HP_max", HP_base)
	if delta_hp > 0:
		HP += delta_hp
	var delta_mp = updated_stats.get("MP_max", MP_base) - MP_max
	MP_max = updated_stats.get("MP_max", MP_base)
	if delta_mp > 0:
		MP += delta_mp
	
	STR = updated_stats.get("STR", STR_base)
	MGK = updated_stats.get("MGK", MGK_base)

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
	HP_base = stats_value.get("HP_max", 10)
	MP_base = stats_value.get("MP_max", 0)
	STR_base = stats_value.get("STR", 1)
	MGK_base = stats_value.get("MGK", 1)
	
	#TODO: turn vuln/resist/immune into passive modifiers
	var vuln: Array = stats_value.get("vulnerability", [])
	for type in vuln:
		vulnerability.append(Globals.string_to_Dmg_type(type))
	var res: Array = stats_value.get("resistant", [])
	for type in res:
		resistant.append(Globals.string_to_Dmg_type(type))
	var immn: Array = stats_value.get("immune", [])
	for type in immn:
		immune.append(Globals.string_to_Dmg_type(type))
	
	SPRITE = stats_value.get("SPRITE", "res://icon.svg")
	PORTRAIT = stats_value.get("PORTRAIT", "res://icon.svg")
	
	calculate_stats()
