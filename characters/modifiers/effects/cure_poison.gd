extends Effect
class_name Cure_poison


func _init(effects_file: String):
	effect_type = "instant"
	
func instant(character: Character):
	character.stats.modifiers.cure("poison")