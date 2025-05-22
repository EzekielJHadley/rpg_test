extends RefCounted
class_name Conversation

var dialogue_start: Dialogue
var current_dialogue: Dialogue
var speakers: Dictionary

var conversation_dict: Dictionary

func _init(covnersation_json: String):
	var json = JSON.new()
	print(FileAccess.file_exists(covnersation_json))
	var json_text = FileAccess.open(covnersation_json, FileAccess.READ).get_as_text()
	var error = json.parse(json_text)
	assert(error == OK)
	conversation_dict = json.data
#	build_conversation(conversation_dict)
	print("starting a conversation")
	
func set_speakers(players: Dictionary, npcs: Array):
	for player_character in players:
		speakers[player_character] = players[player_character].PORTRAIT
	
	for non_player in npcs:
		speakers[non_player.name] = non_player.PORTRAIT

func build_conversation():
	var start =  conversation_dict["_start"]
	dialogue_start =  Dialogue.new(start, speakers.get(start["speaker"], "res://resource/Sprites/icon.svg"))
	current_dialogue = dialogue_start
	var existing_dialogue: Dictionary = {"start":current_dialogue}
	var dialogue_stack: Array[Dialogue] = [current_dialogue]
	while len(dialogue_stack) > 0:
		var  working_dialogue = dialogue_stack.pop_back()
		for choice in working_dialogue.get_responses():
			if working_dialogue.get_response(choice) == null and conversation_dict[choice]["speaker"] in speakers:
				if choice in existing_dialogue:
					working_dialogue.set_response(choice, existing_dialogue[choice])
				else:
					var new_dialogue = Dialogue.new(conversation_dict[choice], speakers[conversation_dict[choice]["speaker"]])
					working_dialogue.set_response(choice, new_dialogue)
					existing_dialogue[choice] = new_dialogue
					dialogue_stack.append(new_dialogue)

				
func end_conversation():
	print("ending conversation")
	dialogue_start.remove()		
	

func add_character_list(characters):
	pass

func start_conversation() -> Dialogue:
	return current_dialogue

func get_next_option(choice: String = "") -> Dialogue:
	current_dialogue = current_dialogue.get_response(choice)
	return current_dialogue
