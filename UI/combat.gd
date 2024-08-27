extends CanvasLayer


signal attack


func _on_attack_pressed() -> void:
	emit_signal("attack")
