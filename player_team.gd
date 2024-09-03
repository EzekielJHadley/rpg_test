extends Node

var team: Dictionary = {}
var available_characters: Dictionary = {}

func _ready() -> void:
	var stats = Stats.new("res://characters/hero.json")
	stats.add_spell(Ice_beam.new())
	stats.add_spell(Fire_bolt.new())
	add_team_member(stats)

func add_team_member(stat: Stats) -> void:
	if stat.character_name not in available_characters:
		available_characters[stat.character_name] = stat
	
	if stat.character_name not in team:
		team[stat.character_name] = stat
