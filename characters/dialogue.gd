extends RefCounted
class_name Dialogue

var speaker: String
var portrait: String
var dialogue: String
var responses: Dictionary
var no_response: bool = false

func _init(dialogue_dict: Dictionary, speaker_portrait: String):
	speaker = dialogue_dict.get("speaker", "")
	portrait = speaker_portrait
	dialogue = dialogue_dict["dialogue"]
	for resp in dialogue_dict.get("responses", []):
		responses[resp] = null
	

func set_response(response: String, next_dialogue: Dialogue) -> void:
	responses[response] = next_dialogue
	if response.begins_with("_") or no_response:
		no_response = true
		assert(len(responses.keys()) == 1, "If you intend to click through, you can only have one response")
	
func get_responses() -> Array:
	return responses.keys()

func get_response(response: String = "") -> Dialogue:
	return responses.get(response, null)

func remove():
	while self.get_reference_count() > 0:
		self.unreference()
	
	for resp in responses:
		if is_instance_valid(responses[resp]):
			responses[resp].remove()