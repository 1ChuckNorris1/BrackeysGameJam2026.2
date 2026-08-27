extends CanvasLayer

signal deleted_wanted_sign

func _ready() -> void:

	$QuitButton.disabled = true
	await get_tree().create_timer(1.0).timeout

	$QuitButton.disabled = false
	
	
func _on_quit_button_pressed() -> void:
	deleted_wanted_sign.emit()
	queue_free()
