extends CanvasLayer


signal attack
signal magic_attack(spell_name:String)
signal use_item(item: Consumable)
signal finished

var chars_per_second: int = 50
var word_delay: float = 0.0

var spells_available: Dictionary
var items_available: Array = []

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
	
func add_items(inventory: Dictionary) -> void:
	items_available.clear()
	for consumable in inventory:
		if inventory[consumable] > 0:
			var item_text = str(inventory[consumable]) + "x " + consumable.name
			var item_display = {"text": item_text, "display":consumable.inv_icon, "item":consumable}
			items_available.append(item_display)

func display(display_type: String, data: Dictionary):
	$"combat_box/Magic_attacks/Spell List".clear()
	$"combat_box/Items/Item List".clear()
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
				$"combat_box/Magic_attacks/Spell List".add_item(spell, load("res://resource/Sprites/icon.svg"))
				$"combat_box/Magic_attacks/Spell List".set_item_disabled(-1, not spells_available[spell])
			$combat_box/Magic_attacks.visible = true
		"item":
			for item_display in items_available:
				$"combat_box/Items/Item List".add_item(item_display["text"], load(item_display["display"]))
			$combat_box/Items.visible = true
		"dialogue":
			$combat_box/dialogue/VBoxContainer/conversation.text = data.get("text", "NaN")
			$combat_box/dialogue/VBoxContainer/conversation.visible_characters = 0
			$combat_box/dialogue/VBoxContainer/speaker.text = data.get("name", "NaN")
			$combat_box/dialogue/speaker_portrait.texture = load(data.get("protrait", "res://resource/Sprites/icon.svg"))
			print("Displaying: " + data["text"])
			$combat_box/dialogue.visible = true

func _on_attack_pressed() -> void:
	attack.emit()

func _on_magic_pressed() -> void:
	display("magic_atk", {})
	
func _on_item_pressed() -> void:
	display("item", {})

func _on_spell_list_item_activated(index: int) -> void:
	var spell_selected = $"combat_box/Magic_attacks/Spell List".get_item_text(index)
	magic_attack.emit(spell_selected)

func _on_item_list_item_activated(index: int) -> void:
	var item = items_available[index]["item"]
	use_item.emit(item)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("continue") and $combat_box/dialogue.visible:
		if $combat_box/dialogue/VBoxContainer/conversation.visible_ratio < 1.0:
			$combat_box/dialogue/VBoxContainer/conversation.visible_ratio = 1
		else:
			$combat_box/dialogue.visible = false
			finished.emit()


func _on_magic_back_pressed() -> void:
	display("player_turn", {})
