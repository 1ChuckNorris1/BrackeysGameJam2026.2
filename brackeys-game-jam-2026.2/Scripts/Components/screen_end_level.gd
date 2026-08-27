extends CanvasLayer


func _ready() -> void:
	$AnimationPlayer.play("RESET")
	
func show_button() -> void:
	SoundeffectsManager.play_sound(SoundeffectsManager.victory_screen_sound)
	$AnimationPlayer.play("show_end_button")
