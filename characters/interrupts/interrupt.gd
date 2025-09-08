extends Node2D
class_name Interrupt

var number_interrupts: int
var type: String = ""

func is_triggered(_stats: Stats) -> bool:
	return false
	
func interrupt_data() -> Dictionary:
	return {}

func interrupt_type() -> String:
	return type
