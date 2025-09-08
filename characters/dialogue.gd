extends RefCounted
class_name Dialogue

var speaker: String
var portrait: String
var dialogue: String
var responses: Dictionary
var restrictions: Array
var no_response: bool = false
var effect: Dictionary

func _init(dialogue_dict: Dictionary, speaker_portrait: String):
	speaker = dialogue_dict.get("speaker", "")
	portrait = speaker_portrait
	dialogue = dialogue_dict["dialogue"]
	restrictions = dialogue_dict.get("when_flag", [])
	for resp in dialogue_dict.get("responses", []):
		responses[resp] = null
		
	effect = dialogue_dict.get("effect", {})

func set_response(response: String, next_dialogue: Dialogue) -> void:
	responses[response] = next_dialogue
	if response.begins_with("_") or no_response:
		no_response = true
		assert(len(responses.keys()) == 1, "If you intend to click through, you can only have one response")
	
func get_responses() -> Array:
	return responses.keys()

func get_valid_responses() -> Array:
	var valid_responses = []
	for response in responses.keys():
		if responses[response].is_available():
			valid_responses.append(response)
	return valid_responses

func trigger_effect():
	if "set_flags" in effect:
		for flag in effect["set_flags"].keys():
			GameFlags.set_flag(flag, effect["set_flags"][flag])

func get_response(response: String = "") -> Dialogue:
	var resp = responses.get(response, null)
	if resp != null:
		resp.trigger_effect()
	return resp
	
func is_available() -> bool:
	var ret = true
	for check in restrictions:
		ret = ret and GameFlags.compare_flag(check.get("flag", "none"), check.get("comp", "eq"), int(check.get("value", "1")))
	return ret

func remove() -> void:
	while self.get_reference_count() > 0:
		self.unreference()
	
	for resp in responses:
		if is_instance_valid(responses[resp]):
			responses[resp].remove()