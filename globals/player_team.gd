extends Node

var team: Dictionary = {}
var available_characters: Dictionary = {}

var inventory: Inventory

func _ready() -> void:
	inventory = Inventory.new()
	inventory.add_item(Antidote.new(), 5)
	
	var hero = Stats.new("res://stats/player_characters/hero.json")
	hero.add_spell(Ice_beam.new())
	hero.add_spell(Fire_bolt.new())
	hero.add_spell(Poison.new())
	hero.add_spell(Fireball.new())
	add_team_member(hero)
	
	var yellow = Stats.new("res://stats/player_characters/yellow.json")
	yellow.add_spell(Minor_heal.new())
	yellow.add_spell(Fire_bolt.new())
	yellow.add_spell(Cure.new())
	yellow.add_spell(MagicMissile.new())
	add_team_member(yellow)

func add_team_member(stat: Stats) -> void:
	if stat.name not in available_characters:
		available_characters[stat.name] = stat
	
	if stat.name not in team:
		team[stat.name] = stat
