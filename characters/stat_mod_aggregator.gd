extends RefCounted
class_name Stat_mod_aggregator

var stats_aggregator = {}

#each stat will have a key of the same name as the stat
#the value will be a dictionary containing the base value (from stats)
#an additive value, to be added to the base before multiplication
#a list of multiplicative values, appeneded with a new multiplier
#the first index of the multiplier will be for the additive multipliers
#the rest will be for the multiplicative multipliers
#then any flat value to be added on top of the caluclated value
#: eg if two sources give an additive +1% and another gives a multiplicative +10%
#then the list will look like: [1.02, 1.10]


func modify_stat(stat:String, operation: int, modifier: float):
	stats_aggregator[stat].add_modifier(operation, modifier)

func calculate() -> Dictionary:
	var ret_val = {}
	for stat in stats_aggregator:
		ret_val[stat] = stats_aggregator[stat].calculate()
	
	return ret_val
