extends RefCounted
class_name ModifierGen


enum types {HERO_BUFF, ASPECT_OF_FIRE}

static func generate(input_type: types):
	var new_mod = null
	match input_type:
		types.HERO_BUFF:
			new_mod = HeroBuff.new()
		types.ASPECT_OF_FIRE:
			new_mod = AspectOfFire.new()
		_ :
			print("Error Consumable type is not defined")
	
	return new_mod
	
	
static func enum_to_string(input_type: types):
	return str(types.keys()[input_type]).capitalize()
	
static func string_to_enum(type_str: String):
	return types[type_str.to_upper().replace(" ", "_")]
