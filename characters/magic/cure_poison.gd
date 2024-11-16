extends Magic
class_name Cure

func _init():
	super("Cure Poison", Globals.Dmg_type.NONE, "MGK", 2)
	#add spell scene here

func get_spell_attack(stats: Stats) -> Globals.Damage_info:
	var damage: int = 0
	effects = [Cure_poison.new("")]
	return Globals.Damage_info.new(element, damage, effects)
