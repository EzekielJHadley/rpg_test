extends Interrupt

var dialogue: String

func _init() -> void:
	number_interrupts = 1
	type = "dialogue"
	
	dialogue = "res://stats/conversations/half_health.json"

func is_triggered(stats: Stats) -> bool:
	if number_interrupts > 0:
		if stats.HP*2 < stats.HP_max:
#			dialogue["name"] = stats.name
#			dialogue["protrait"] = stats.PORTRAIT
			number_interrupts -= 1
			return true
	return false
	
func interrupt_data() -> Dictionary:
	var conv = FileManager.load_json(dialogue)
	return {"conversation":Conversation.new(conv)}
