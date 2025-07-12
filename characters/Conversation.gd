extends RefCounted
class_name Conversation

var dialogue_start: Dialogue
var current_dialogue: Dialogue
var initial_speaker: String
var speakers: Dictionary
var targets: Dictionary

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
	
func set_speakers(players: Array, npcs: Array, speaker: String):
	for player_character in players:
		speakers[player_character.name] =player_character.PORTRAIT
		targets[player_character.name] = [player_character]
	
	for non_player in npcs:
		speakers[non_player.name] = non_player.PORTRAIT
		targets[non_player.name] = [non_player]
		
	initial_speaker = speaker
	
	targets["ALL_ALLIES"] = players
	targets["ALL_ENEMIES"] = npcs
	targets["SPEAKER"] = targets[initial_speaker]
	
func _get_attack(attack_info: Dictionary):
	var dmg_type = Damage_info.string_to_Dmg_type(attack_info["type"]) 
	return Damage_info.new(dmg_type, attack_info["dmg"], attack_info["status"])

func build_conversation():
	var start: Dictionary =  conversation_dict["_start"]
	if start["speaker"] == "SPEAKER":
		start["speaker"] = initial_speaker
	if start.has("effect"):
		start["effect"]["targets"] = targets[start["effect"]["targets"]]
		start["effect"]["attack"] = _get_attack(start["effect"]["attack"])
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
					if conversation_dict[choice]["speaker"] == "SPEAKER":
						conversation_dict[choice]["speaker"] = initial_speaker
					if conversation_dict[choice].has("effect"):
						conversation_dict[choice]["effect"]["targets"] = targets[conversation_dict[choice]["effect"]["targets"]]
						conversation_dict[choice]["effect"]["attack"] = _get_attack(conversation_dict[choice]["effect"]["attack"])
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
