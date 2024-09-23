extends Magic
class_name Minor_heal

func _init():
	super("Minor Heal", Globals.Dmg_type.LIGHT, "MGK", 2)
	#add spell scene here

func get_spell_attack(stats: Stats) -> Globals.Damage_info:
	var damage: int = - stats.get(base_stat)
	
	return Globals.Damage_info.new(element, damage, effects)
