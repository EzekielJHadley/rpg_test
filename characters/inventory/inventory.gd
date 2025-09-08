extends RefCounted
class_name Inventory


var consumables: Dictionary = {}
var consumable_gen = ConsumableGen.new()

func add_item(item_enum, quantity: int = 1):
	var item = consumable_gen.generate(item_enum)
	if item in consumables:
		consumables[item] += quantity
	else:
		consumables[item] = quantity

func use_item(item):
	if item in consumables:
		consumables[item] -= 1
		return item.use_item()
	else:
		print("Error!: Item does not exist or you are out of item.")
		return Damage_info.new(0, 0, [])

func export_items():
	var out = {}
	
	for item in consumables.keys():
		out[item.name] = consumables[item]
		
	return out

func import_items(new_items: Dictionary):
	consumables = {}
	for item in new_items.keys():
		var item_type = ConsumableGen.string_to_enum(item)
		add_item(item_type, new_items[item])