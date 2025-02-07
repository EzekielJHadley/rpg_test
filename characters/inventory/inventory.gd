extends RefCounted
class_name Inventory


var consumables: Dictionary = {}

func add_item(item: Consumable, quantity: int = 1):
	if item in consumables:
		consumables[item] += quantity
	else:
		consumables[item] = quantity

func use_item(item: Consumable):
	if item in consumables:
		consumables[item] -= 1
		return item.use_item()
	else:
		print("Error!: Item does not exist or you are out of item.")
		return Damage_info.new(0, 0, [])
