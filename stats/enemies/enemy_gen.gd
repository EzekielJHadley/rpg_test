extends RefCounted
class_name EnemyGen

enum types {SLIME_GIRL, ZOMBIE, BOSS_GOAT}

static func generate(input_type: types):
	var new_enemy = null
	match input_type:
		types.SLIME_GIRL:
			new_enemy = "res://stats/enemies/slime_girl.json"
		types.ZOMBIE:
			new_enemy = "res://stats/enemies/zombie.json"
		types.BOSS_GOAT:
			new_enemy = "res://stats/bosses/goat_boss.json"
		_ :
			print("Error Consumable type is not defined")
	
	return new_enemy
	
	
static func enum_to_string(input_type: types):
	return str(types.keys()[input_type]).capitalize()
	
static func string_to_enum(type_str: String):
	return types[type_str.to_upper().replace(" ", "_")]
