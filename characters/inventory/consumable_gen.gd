extends RefCounted
class_name ConsumableGen

# When adding a new enum, the string's spaces will be replaced with underscore
# the string will not be case sensative, see string_to_enum
enum types {ANTIDOTE, SM_POTION}

var item_cache = {}
var item_defs = {}

func _init():
	var item_raw = FileManager.load_json("res://characters/inventory/consumables.json")
	for item_name in item_raw:
		var item_type = string_to_enum(item_name)
		item_defs[item_type] = item_raw[item_name]
		
	

func generate(input_type: types):
	var new_consumable = null
	if input_type in item_defs.keys():
		if input_type in item_cache:
			new_consumable = item_cache[input_type]
		else:
			var dmg_type = item_defs[input_type].get("dmg_type", "none")
			dmg_type = Damage_info.string_to_Dmg_type(dmg_type)
			var dmg = item_defs[input_type].get("dmg", 0)
			var effects = item_defs[input_type].get("effects", [])
			new_consumable = Consumable.new(dmg_type, dmg, effects)
			item_cache[input_type] = new_consumable
	else:
		print("Consumable not found")
	
	return new_consumable
	
	
static func enum_to_string(input_type: types):
	return str(types.keys()[input_type]).capitalize()
	
static func string_to_enum(type_str: String):
	return types[type_str.to_upper().replace(" ", "_")]