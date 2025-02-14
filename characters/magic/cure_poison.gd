extends Magic
class_name Cure

func _init():
	super("Cure Poison", Damage_info.Dmg_type.NONE, "MGK", 2)
	#add spell scene here

func get_spell_attack(_stats: Stats) -> Damage_info:
	var damage: int = 0
	effects = [Cure_poison.new("")]
	return Damage_info.new(element, damage, effects)
