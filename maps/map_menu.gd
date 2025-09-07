extends CanvasLayer

signal save_game

func _on_visibility_changed():
	if is_inside_tree():
		$menu/resume.grab_focus()

func _on_resume_pressed():
	visible = false
	get_tree().paused = false
	
func _on_save_pressed():
	save_game.emit()
