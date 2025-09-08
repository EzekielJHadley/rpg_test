extends RefCounted
class_name InterruptGen


enum types {HALF_HEALTH}

static func generate(input_type: types):
	var new_interrupt = null
	match input_type:
		types.HALF_HEALTH:
			new_interrupt = "res://characters/interrupts/half_health.tscn"
		_ :
			print("Error Consumable type is not defined")
	
	return load(new_interrupt).instantiate()
	
	
static func enum_to_string(input_type: types):
	return str(types.keys()[input_type]).capitalize()
	
static func string_to_enum(type_str: String):
	return types[type_str.to_upper().replace(" ", "_")]

