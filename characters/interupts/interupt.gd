extends Node2D
class_name Interupt

var number_interupts: int
var type: String = ""

func is_triggered(_stats: Stats) -> bool:
	return false
	
func interupt_data() -> Dictionary:
	return {}

func interupt_type() -> String:
	return type
