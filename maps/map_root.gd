extends Level_root

var conv: Conversation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var doors: Array[Node] = get_tree().get_nodes_in_group("doors")
	for doorway in doors:
		print(doorway)
		doorway.change_scene.connect(change_scene)
	$dialogue.Event.connect(event_handler)
	for interactable in get_tree().get_nodes_in_group("interactable"):
		print(interactable)
		interactable.Event.connect(event_handler)
		
	
	
func event_handler(character, event_type: String, data: Dictionary):
	match event_type:
		"start_dialogue":
			get_tree().paused = true
			conv = data["conversation"]
			conv.set_speakers(PlayerTeam.team.values(), get_tree().get_nodes_in_group("interactable"), character.name)
			conv.build_conversation()
			var diag := conv.start_conversation()
			print(diag.dialogue)
			print(diag.get_responses())
			$dialogue.load_dialogue(diag)
		"next_dialogue":
			print("Did that work?")
			print("you chose: " + data["choice"])
			var diag = conv.get_next_option(data["choice"])
			#put effect here
			$dialogue.load_dialogue(diag)
		"end_dialogue":
			print("end dialogue")
			conv.end_conversation()
			conv = null
			get_tree().paused = false
			GameFlags.set_flag("flag_test")
			

func set_up(data: Dictionary):
	if data.has("door"):
		$PCs/player1.position = get_node("door/" + data["door"]).position
