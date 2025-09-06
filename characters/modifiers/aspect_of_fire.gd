extends Modifiers
class_name AspectOfFire

func _init():
	name = "Aspect Of Fire"
	#change base attack to do fire damage
	attk_mods.append({"dmg_type":Damage_info.Dmg_type.FIRE})
	#take half damage, multiplicative, from fire attacks
	def_mods.append({"operator":Mod_calculator.MULTIPLIER, "modifier":-0.5,"dmg_type":Damage_info.Dmg_type.FIRE})
	#take half damage, multiplicative, from fire attacks
	def_mods.append({"operator":Mod_calculator.MULTIPLIER, "modifier":1,"dmg_type":Damage_info.Dmg_type.ICE})
