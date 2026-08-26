extends AudioStreamPlayer

var is_playing_music: bool = false


func start_music():
	is_playing_music = true
	play()

func stop_music():
	is_playing_music = false
	stop()

func _on_finished() -> void:
	if is_playing_music:
		play(0.0)
