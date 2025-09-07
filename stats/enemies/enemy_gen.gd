extends RefCounted
class_name EnemyGen

enum types {SLIME_GIRL_G, SLIME_GIRL_B, ZOMBIE_M, ZOMBIE_C, BOSS_GOAT}

static func generate(input_type: types):
	var new_enemy = null
	match input_type:
		types.SLIME_GIRL_G:
			new_enemy = "res://stats/enemies/slime_girl_g.json"
		types.SLIME_GIRL_B:
			new_enemy = "res://stats/enemies/slime_girl_b.json"
		types.ZOMBIE_M:
			new_enemy = "res://stats/enemies/zombie_m.json"
		types.ZOMBIE_C:
			new_enemy = "res://stats/enemies/zombie_c.json"
		types.BOSS_GOAT:
			new_enemy = "res://stats/bosses/goat_boss.json"
		_ :
			print("Error Consumable type is not defined")
	
	return new_enemy
	
	
static func enum_to_string(input_type: types):
	return str(types.keys()[input_type]).capitalize()
	
static func string_to_enum(type_str: String):
	return types[type_str.to_upper().replace(" ", "_")]
