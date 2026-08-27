extends CanvasLayer

signal deleted_wanted_sign


func _on_quit_button_pressed() -> void:
	deleted_wanted_sign.emit()
	queue_free()
