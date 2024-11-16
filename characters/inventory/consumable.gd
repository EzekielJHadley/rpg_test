extends RefCounted
class_name Consumable

var name

var inv_icon = "res://resource/Sprites/icon.svg"
var map_sprite = "res://resource/Sprites/icon.svg"
var battle_sprite = "res://resource/Sprites/icon.svg"

var effects: Array = []


func use_item():
	var out_effect = []
	for effect in effects:
		out_effect.append(effect.new(""))
	return Globals.Damage_info.new(Globals.Dmg_type.NONE, 0, out_effect)
