extends Magic
class_name Poison

func _init():
	super("Poison", Globals.Dmg_type.POISON, "MGK", 2)
	#add spell scene here

func get_spell_attack(stats: Stats) -> Globals.Damage_info:
	var damage: int = 0
	effects = [Poison_effect.new("")]
	return Globals.Damage_info.new(element, damage, effects)
