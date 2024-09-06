extends CanvasLayer


signal attack
signal magic_attack(spell_name:String)
signal finished

var chars_per_second: int = 50
var word_delay: float = 0.0

var spells_available: Dictionary

func _process(delta: float) -> void:
	if $combat_box/dialogue.visible:
		if $combat_box/dialogue/VBoxContainer/conversation.visible_ratio < 1.0:
			if word_delay >= (1.0 / chars_per_second):
				$combat_box/dialogue/VBoxContainer/conversation.visible_characters += 1
				word_delay = 0
			else:
				word_delay += delta
			
func add_spells(spell_list: Dictionary) -> void:
	spells_available = spell_list

func display(display_type: String, data: Dictionary):
	$"combat_box/Magic_attacks/Spell List".clear()
	for ui_element in $combat_box.get_children():
		ui_element.visible = false
	visible = true
	match display_type:
		"player_turn":
			if len(spells_available) > 0:
				$combat_box/Player_actions/Magic.disabled = false
			else:
				$combat_box/Player_actions/Magic.disabled = true
			$combat_box/Player_actions.visible = true
		"magic_atk":
			for spell in spells_available.keys():
				$"combat_box/Magic_attacks/Spell List".add_item(spell, load("res://icon.svg"))
				$"combat_box/Magic_attacks/Spell List".set_item_disabled(-1, not spells_available[spell])
			$combat_box/Magic_attacks.visible = true
		"dialogue":
			$combat_box/dialogue/VBoxContainer/conversation.text = data.get("text", "NaN")
			$combat_box/dialogue/VBoxContainer/conversation.visible_characters = 0
			$combat_box/dialogue/VBoxContainer/speaker.text = data.get("name", "NaN")
			$combat_box/dialogue/speaker_portrait.texture = load(data.get("protrait", "res://icon.svg"))
			print("Displaying: " + data["text"])
			$combat_box/dialogue.visible = true

func _on_attack_pressed() -> void:
	attack.emit()

func _on_magic_pressed() -> void:
	display("magic_atk", {})

func _on_spell_list_item_activated(index: int) -> void:
	var spell_selected = $"combat_box/Magic_attacks/Spell List".get_item_text(index)
	magic_attack.emit(spell_selected)
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			if $combat_box/dialogue/VBoxContainer/conversation.visible_ratio < 1.0:
				$combat_box/dialogue/VBoxContainer/conversation.visible_ratio = 1
			else:
				$combat_box/dialogue.visible = false
				finished.emit()


func _on_magic_back_pressed() -> void:
	display("player_turn", {})
