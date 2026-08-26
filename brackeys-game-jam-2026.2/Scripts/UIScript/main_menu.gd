extends Control

func _ready() -> void:
	if MenuMusic.playing == false:
		MenuMusic.playing = true
