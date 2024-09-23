extends RefCounted
class_name Mod_calculator

enum {NONE, ADDITIVE, ADD_MULTI, MULTIPLIER, FLAT}

var ADDITIVE_PERCENT_INDEX = 0

var aggregator: Dictionary

func _init(base:int):
	aggregator = {"base":base, "addition":0, "multiplication":[1.0], "on top":0}
	
func add_modifier(operation: int, modifier: float):
	match operation:
		ADDITIVE:
			aggregator["addition"] += modifier
		ADD_MULTI:
			aggregator["multiplication"][ADDITIVE_PERCENT_INDEX] += modifier
		MULTIPLIER:
			aggregator["multiplication"].append(1+modifier)
		FLAT:
			aggregator["on top"] += modifier
		_:
			print("Unrecognized operation, please check the docs for the correct types")
			
func calculate() -> int:
	var ret_val: int
	var add: float = float(aggregator["base"] + aggregator["addition"])
	var multi: float = add * aggregator["multiplication"].reduce(func (accum, num): return accum*num)
	var ret: float = multi + aggregator["on top"]
	ret_val = floor(ret)
	
	return ret_val
