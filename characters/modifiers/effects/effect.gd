extends Modifiers
class_name Effect

signal end_effect

var effect_type: String
var effect_timer: int
var effect_icon: TextureRect
var has_icon: bool = false
var effect_animation: Animation_engine


func _init(effects_file: String):
	pass
	

func on_turn_start(character: Character):
	pass

func instant(character: Character):
	pass
		
	
func get_icon() -> TextureRect:
	self.connect("end_effect", effect_icon.queue_free)
	return effect_icon

func remove():
	end_effect.emit()

func load_from_json(file_name: String):
	var json = JSON.new()
	var json_text = FileAccess.open(file_name, FileAccess.READ).get_as_text()
	var error = json.parse(json_text)
	assert(error == OK)
	var stats_value = json.data
