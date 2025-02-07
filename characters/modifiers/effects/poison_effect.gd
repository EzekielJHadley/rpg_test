extends Effect
class_name Poison_effect


func _init(_effects_file: String):
	effect_type = Damage_info.Status_effect.keys()[Damage_info.Status_effect.POISON]
	effect_timer = 2
	has_icon = true
	effect_icon = TextureRect.new()
	effect_icon.texture = load("res://resource/UI/poison_effect.bmp")
	

func on_turn_start(character: Character):
	effect_animation = Animation_engine.new()
	character.add_child(effect_animation)
	effect_animation.set_animation("res://resource/UI/poison_animation.bmp", 4, 2, 1)
	effect_animation.add_behavior("modulate:a", 0, 2)
	effect_animation.position.y -= character.texture.get_height()/2.0
	await effect_animation.run()
	var poison = Damage_info.new(Damage_info.Dmg_type.POISON, 1, [])
	character.take_dmg(poison)
	effect_timer -= 1
	if effect_timer <= 0:
		print("Ending Poison effect")
		end_effect.emit()
