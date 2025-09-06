extends RefCounted
class_name Stats

signal health_update(new_hp)
signal mana_update(new_mp)

var name: String = ""

var HP_base: int
var MP_base: int
var STR_base: int
var SPD_base: int
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
var SPD: int
var MGK: int

var spells_available: Dictionary = {}
var modifiers: Char_mods


var SPRITE: String
var sprite_width: int
var sprite_height: int
var PORTRAIT: String

func _init() -> void:
	modifiers = Char_mods.new()

func add_spell(new_spell: SpellGen.types):
	spells_available[SpellGen.enum_to_string(new_spell)] = SpellGen.generate(new_spell)
	

func get_attacks() -> Dictionary:
	var available_attacks = {}
	available_attacks["Base_Attack"] = {"name": "Attack", "attack":null}
	available_attacks["Magic"] = spells_available
	available_attacks["available_mana"] = MP
	
	return available_attacks
	
func calculate_stats():
	var aggregator = Stat_mod_aggregator.new({"HP_max":HP_base, "MP_max":MP_base,"STR":STR_base, "MGK":MGK_base})
	for passive in modifiers.get_mods():
		passive.stats_modifier(aggregator)
	var updated_stats = aggregator.calculate()
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
	SPD = updated_stats.get("SPD", SPD_base)
	MGK = updated_stats.get("MGK", MGK_base)

func base_attk() -> Damage_info:
	var dmg = STR
	var base_dmg = Damage_info.new(Damage_info.Dmg_type.PHYSICAL, dmg, [])
	
	var aggregator = Dmg_mod_aggregator.new(base_dmg)
	for passive in modifiers.get_mods():
		passive.dmg_modifier(aggregator)
		
	var final_dmg = aggregator.calculate()
	
	return final_dmg

func magic_attk(spell_name: String) -> Damage_info:
	var spell:Magic = spells_available.get(spell_name, Magic.new("null", Damage_info.Dmg_type.NONE, "STR", 0))
	MP -= spell.cost
	
	var aggregator = Dmg_mod_aggregator.new(spell.get_spell_attack(self))
	for passive in modifiers.get_mods():
		passive.magic_modifiers(aggregator)
	
	var final_spell_attk = aggregator.calculate()
	return final_spell_attk
	
func defend(incoming_attack: Damage_info):
	var aggregator = Def_mod_aggregator.new(incoming_attack)
	for passive in modifiers.get_mods():
		passive.def_modifier(aggregator)
	
	var final_dmg = aggregator.calculate()
	print(name + ": I'm taking: " + str(final_dmg.damage) + " " + Damage_info.Dmg_type_to_string(final_dmg.element) + " damage!")
	HP -= final_dmg.damage
	
func load_from_json(file_name: String):
#	var json = JSON.new()
#	print(FileAccess.file_exists(file_name))
#	var json_text = FileAccess.open(file_name, FileAccess.READ).get_as_text()
#	var error = json.parse(json_text)
#	assert(error == OK)
#	var stats_value = json.data
	load_from_dict(FileManager.load_json(file_name))
	
func load_from_dict(stats_value: Dictionary):
	name = stats_value.get("character_name", "NaN")
  
	HP_base = stats_value.get("HP_max", 10)
	MP_base = stats_value.get("MP_max", 0)
	STR_base = stats_value.get("STR", 1)
	SPD_base = stats_value.get("SPD", 1)
	MGK_base = stats_value.get("MGK", 1)
	
  
	SPRITE = stats_value.get("SPRITE", "res://resource/Sprites/icon.svg")
	sprite_width = stats_value.get("sprite_width", 1)
	sprite_height = stats_value.get("sprite_height", 1)

	PORTRAIT = stats_value.get("PORTRAIT", "res://resource/Sprites/icon.svg")

	#passives
	for skill_name in stats_value.get("Passives", []):
		var skill_type = ModifierGen.string_to_enum(skill_name)
		var skill = ModifierGen.generate(skill_type)
		modifiers.add_mod(skill)
		
	for spell_name in stats_value.get("Spells", []):
		var spell_type = SpellGen.string_to_enum(spell_name)
		add_spell(spell_type)

	
	calculate_stats()

func export_values():
	var out = {}
	out["character_name"] = name
	out["HP_max"] = HP_base  
	out["MP_max"] = MP_base  
	out["STR"] = STR_base
	out["SPD"] = SPD_base
	out["MGK"] = MGK_base
	out["SPRITE"] = SPRITE
	out["sprite_width"] = sprite_width
	out["sprite_height"] = sprite_height
	out["PORTRAIT"] = PORTRAIT
	out["Passives"] = modifiers.export_passives()
	out["Spells"] = spells_available.keys()
	
	return out

func import_values(new_stats: Dictionary):
	spells_available = {}
	modifiers = Char_mods.new()
	load_from_dict(new_stats)