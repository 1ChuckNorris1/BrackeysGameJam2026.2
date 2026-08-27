extends Control

func _ready() -> void:
	if MenuMusic.is_playing_main_menu_music == false:
		MenuMusic.start_main_menu_music()
