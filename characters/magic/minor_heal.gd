extends Magic
class_name Minor_heal

func _init():
	super("Minor Heal", Damage_info.Dmg_type.LIGHT, "MGK", 2)
	#add spell scene here

func get_spell_attack(stats: Stats) -> Damage_info:
	var damage: int = - stats.get(base_stat)
	
	return Damage_info.new(element, damage, effects)
