extends Resource
class_name ItemSelect

@export var quantity: int
@export_file("*.gd") var item_source: String = "res://characters/inventory/"


func load_item():
	return load(item_source)
	
