extends RefCounted
class_name Inventory


var consumables: Dictionary = {}
var items: Dictionary = {}

func add_item(item, quantity: int = 1):
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

#func gen_item(script: String):
#	var item_obj: Consumable = script.load_item()
#	if item_obj.name in items:
#		return item_obj
#	else:
#		items[item_obj.name] = item_obj
