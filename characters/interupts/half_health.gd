extends Interupt

var dialogue: String

func _init() -> void:
	number_interupts = 1
	type = "dialogue"
	
	dialogue = "res://stats/conversations/half_health.json"

func is_triggered(stats: Stats) -> bool:
	if number_interupts > 0:
		if stats.HP*2 < stats.HP_max:
#			dialogue["name"] = stats.name
#			dialogue["protrait"] = stats.PORTRAIT
			number_interupts -= 1
			return true
	return false
	
func interupt_data() -> Dictionary:
	var conv = FileManager.load_json(dialogue)
	return {"conversation":Conversation.new(conv)}
