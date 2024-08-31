extends CanvasLayer


signal attack
signal finished

var words_per_second: int = 5
var word_delay: float = 0.0

func _process(delta: float) -> void:
	if $combat_box/dialogue.visible:
		if $combat_box/dialogue/VBoxContainer/conversation.visible_ratio < 1.0:
			if word_delay >= 1 / words_per_second:
				$combat_box/dialogue/VBoxContainer/conversation.visible_characters += 1
				word_delay = 0
			else:
				word_delay += delta
			

func display(display_type: String, data: Dictionary):
	$combat_box/Player_actions.visible = false
	$combat_box/dialogue.visible = false
	visible = true
	match display_type:
		"player_turn":
			$combat_box/Player_actions.visible = true
		"dialogue":
			$combat_box/dialogue/VBoxContainer/conversation.text = data.get("text", "NaN")
			$combat_box/dialogue/VBoxContainer/conversation.visible_characters = 0
			$combat_box/dialogue/VBoxContainer/speaker.text = data.get("name", "NaN")
			$combat_box/dialogue/speaker_portrait.texture = load(data.get("protrait", "res://icon.svg"))
			print("Displaying: " + data["text"])
			$combat_box/dialogue.visible = true

func _on_attack_pressed() -> void:
	emit_signal("attack")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			if $combat_box/dialogue/VBoxContainer/conversation.visible_ratio < 1.0:
				$combat_box/dialogue/VBoxContainer/conversation.visible_ratio = 1
			else:
				$combat_box/dialogue.visible = false
				finished.emit()
