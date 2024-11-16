extends Consumable
class_name Antidote


func _init():
	name = "antidote"
	effects.append(Cure_poison)