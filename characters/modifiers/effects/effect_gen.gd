extends RefCounted
class_name EffectGen


enum types {CURE_POISON, POISON}

static func generate(input_type: types):
	var new_effect = null
	match input_type:
		types.CURE_POISON:
			new_effect = Cure_poison
		types.POISON:
			new_effect = Poison_effect
		_ :
			print("Error Consumable type is not defined")
	
	return new_effect
	
	
static func enum_to_string(input_type: types):
	return str(types.keys()[input_type]).capitalize()
	
static func string_to_enum(type_str: String):
	return types[type_str.to_upper().replace(" ", "_")]
