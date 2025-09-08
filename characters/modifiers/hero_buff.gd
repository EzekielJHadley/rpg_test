extends Modifiers
class_name HeroBuff


func _init():
	name = "Hero Buff"
	stat_mods.append({"stat":"STR", "operator":Mod_calculator.ADDITIVE, "modifier":1})

func on_turn_start(character: Character):
	await character.get_tree().create_timer(0.5).timeout
	character.stats.HP += 1
	await character.get_tree().create_timer(0.6).timeout
	character.stats.MP += 1
