extends RefCounted
class_name Consumable

static var name

var inv_icon = "res://resource/Sprites/icon.svg"
var map_sprite = "res://resource/Sprites/icon.svg"
var battle_sprite = "res://resource/Sprites/icon.svg"

var effects: Array = []
var dmg_type: Damage_info.Dmg_type = Damage_info.Dmg_type.NONE
var dmg: int = 0

func _init(cons_name: String, damage_type: Damage_info.Dmg_type = Damage_info.Dmg_type.NONE, damage: int = 0, effects_str: Array = []):
	name = cons_name
	dmg_type = damage_type
	dmg = damage
	for effect_name in effects_str:
		var effect_type: EffectGen.types = EffectGen.string_to_enum(effect_name)
		effects.append(EffectGen.generate(effect_type))
		 

func use_item():
	var out_effect = []
	for effect in effects:
		out_effect.append(effect.new(""))
	return Damage_info.new(dmg_type, dmg, out_effect)
