extends Magic
class_name Poison

func _init():
	super("Poison", Damage_info.Dmg_type.POISON, "MGK", 2)
	#add spell scene here

func get_spell_attack(_stats: Stats) -> Damage_info:
	var damage: int = 0
	effects = [Poison_effect.new("")]
	return Damage_info.new(element, damage, effects)
