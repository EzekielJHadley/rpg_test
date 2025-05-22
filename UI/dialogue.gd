extends CanvasLayer

signal Event(event_type: String, data: Dictionary)

var current_dialogue: Dialogue
var auto_continue: String = ""
var end_conversation: bool = false

var chars_per_second: int = 50
var word_delay: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	if self.visible:
		if $dialogue_box/dialogue/text_box/conversation.visible_ratio < 1.0:
			if word_delay >= (1.0 / chars_per_second):
				$dialogue_box/dialogue/text_box/conversation.visible_characters += 1
				word_delay = 0
			else:
				word_delay += delta
		else:
			$choices.visible = true

func clear():
	for child in $choices.get_children():
		child.queue_free()
	auto_continue = ""
	end_conversation = false

func load_dialogue(text_packet: Dialogue):
	self.visible = true
	$choices.visible = false
	
	current_dialogue = text_packet
	$dialogue_box/dialogue/text_box/conversation.text = text_packet.dialogue
	$dialogue_box/dialogue/text_box/conversation.visible_characters = 0
	$dialogue_box/dialogue/text_box/speaker.text = text_packet.speaker
	$dialogue_box/dialogue/speaker_portrait.texture = load(text_packet.portrait)
	
	clear()
	for resp:String in text_packet.get_responses():
		var choice := Button.new()
		if resp.begins_with("_"):
			auto_continue = resp
		else:
			assert(auto_continue == "")
			choice.text = resp
			choice.pressed.connect(func(): Event.emit("next_dialogue", {"choice": resp}))
			$choices.add_child(choice)
	if len(text_packet.get_responses()) == 0:
		end_conversation = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("continue") and self.visible:
		if $dialogue_box/dialogue/text_box/conversation.visible_ratio < 1.0:
			$dialogue_box/dialogue/text_box/conversation.visible_ratio = 1
		elif auto_continue != "":
			Event.emit("next_dialogue", {"choice": auto_continue})
		elif end_conversation:
			print("Ending the conversation")
			Event.emit("end_dialogue", {})
			self.visible = false