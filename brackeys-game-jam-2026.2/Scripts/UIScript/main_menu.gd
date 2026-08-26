extends Control

func _ready() -> void:
	if MenuMusic.is_playing_music == false:
		MenuMusic.start_music()
