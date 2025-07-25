extends Node

#dictionary of str:int
var flags: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flags = {}
	pass # Replace with function body.


func check_flag(flag_name: String) -> bool:
	if flag_name in flags:
		return flags[flag_name] > 0
	else:
		flags[flag_name] = 0
		return false
		
func compare_flag(flag_name: String, comp: String, value: int) -> bool:
	if not flag_name in flags:
		return false
	
	comp = comp.to_lower()
	var flag_value = flags[flag_name]
	
	#just check the overlap of these three symbols
	if flag_value == value and (comp == "eq" or comp == "lte" or comp == "gte"):
		return true
	
	match comp:
		"lt", "lte":
			return flag_value < value
		"gt", "gte":
			return flag_value > value
		_:
			return false

func get_flag(flag_name: String) -> int:
	if not flag_name in flags:
		flags[flag_name] = 0
	
	return flags[flag_name]

func set_flag(flag_name: String, val: int = 1) -> void:
	flags[flag_name] = val
	
func unset_flag(flag_name: String) -> void:
	set_flag(flag_name, 0)