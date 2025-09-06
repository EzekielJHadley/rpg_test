extends Node

var team: Dictionary = {}
var available_characters: Dictionary = {}

var inventory: Inventory

func _ready() -> void:
	inventory = Inventory.new()
	inventory.add_item(ConsumableGen.types.ANTIDOTE, 1)
	
	var hero = Stats.new()
	hero.load_from_json("res://stats/player_characters/hero.json")
	hero.add_spell(SpellGen.types.ICE_BEAM)
	hero.add_spell(SpellGen.types.FIRE_BOLT)
	hero.add_spell(SpellGen.types.POISON)
	hero.add_spell(SpellGen.types.FIREBALL)
	add_team_member(hero)
	
	var yellow = Stats.new()
	yellow.load_from_json("res://stats/player_characters/yellow.json")
	yellow.add_spell(SpellGen.types.MINOR_HEAL)
	yellow.add_spell(SpellGen.types.FIRE_BOLT)
	yellow.add_spell(SpellGen.types.CURE_POISON)
	yellow.add_spell(SpellGen.types.MAGIC_MISSILE)
	add_team_member(yellow)

func add_team_member(stat: Stats) -> void:
	if stat.name not in available_characters:
		available_characters[stat.name] = stat
	
	if stat.name not in team:
		team[stat.name] = stat

func export_team():
	var out = {"team":{}, "inventory":{}}
	for character in team.keys():
		out["team"][character] = team[character].export_values()
#	inventory
	out["inventory"] = inventory.export_items()
	
	return out

func import_team(new_team: Dictionary, new_inventory: Dictionary):
	inventory = Inventory.new()
	inventory.import_items(new_inventory)
	
	team = {}
	for hero in new_team:
		var new_pc = Stats.new()
		new_pc.load_from_dict(new_team[hero])
		add_team_member(new_pc)
	