extends RefCounted
class_name SpellGen


enum types {CURE_POISON, FIRE_BOLT, FIREBALL, ICE_BEAM, MAGIC_MISSILE, MINOR_HEAL, POISON}

static func generate(input_type: types):
	var new_spell = null
	match input_type:
		types.CURE_POISON:
			new_spell = Cure.new()
		types.FIRE_BOLT:
			new_spell = Fire_bolt.new()
		types.FIREBALL:
			new_spell = Fireball.new()
		types.ICE_BEAM:
			new_spell = Ice_beam.new()
		types.MAGIC_MISSILE:
			new_spell = MagicMissile.new()
		types.MINOR_HEAL:
			new_spell = Minor_heal.new()
		types.POISON:
			new_spell = Poison.new()
		_ :
			print("Error Spell type is not defined")
	
	return new_spell
	
	
static func enum_to_string(input_type: types):
	return str(types.keys()[input_type]).capitalize()
	
static func string_to_enum(type_str: String):
	return types[type_str.to_upper().replace(" ", "_")]
