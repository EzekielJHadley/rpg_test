extends RefCounted
class_name Stats

var character_name: String = ""

var HP_max: int
var HP: int
var STR: int
var MGK: int

var spells_available: Dictionary = {}

var SPRITE: String = "res://icon.svg"
var PORTRAIT: String = "res://icon.svg"

func _init(name: String, hp:int, strn:int, magic:int, sprite:String) -> void:
	character_name = name
	HP_max = hp
	HP = hp
	STR = strn
	MGK = magic
	
	SPRITE = sprite
	PORTRAIT = sprite

func add_spell(new_spell: Magic):
	spells_available[new_spell.name] = new_spell

func base_attk() -> Dictionary:
	var dmg = STR
	return {"type": "physical", "dmg":dmg, "status":null}

func magic_attk(spell_name: String) -> Dictionary:
	var spell:Magic = spells_available.get(spell_name, Magic.new("null", "null", "STR"))
	return spell.get_spell_attack(self)
	
