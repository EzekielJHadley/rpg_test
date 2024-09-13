extends Node

var team: Dictionary = {}
var available_characters: Dictionary = {}

func _ready() -> void:
	var hero = Stats.new("res://characters/hero.json")
	hero.add_spell(Ice_beam.new())
	hero.add_spell(Fire_bolt.new())
	add_team_member(hero)
	
	var yellow = Stats.new("res://characters/yellow.json")
	yellow.add_spell(Minor_heal.new())
	yellow.add_spell(Fire_bolt.new())
	add_team_member(yellow)

func add_team_member(stat: Stats) -> void:
	if stat.character_name not in available_characters:
		available_characters[stat.character_name] = stat
	
	if stat.character_name not in team:
		team[stat.character_name] = stat
