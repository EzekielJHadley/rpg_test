extends Interupt

var dialogue: Dictionary

func _init() -> void:
	number_interupts = 1
	type = "dialogue"
	
	var json = JSON.new()
	var json_text = FileAccess.open("res://characters/interupts/half_health.json", FileAccess.READ).get_as_text()
	var error = json.parse(json_text)
	assert(error == OK)
	dialogue = json.data

func is_triggered(stats: Stats) -> bool:
	if number_interupts > 0:
		if stats.HP*2 < stats.HP_max:
			dialogue["name"] = stats.character_name
			dialogue["protrait"] = stats.PORTRAIT
			number_interupts -= 1
			return true
	return false
	
func interupt_data() -> Dictionary:
	return dialogue
