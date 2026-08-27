extends AudioStreamPlayer

@export var main_menu_music: AudioStream = preload("res://assets/Sounds/Music/menu-music.wav")
@export var in_game_music: AudioStream = preload("res://assets/Sounds/Music/in-game-music.wav")
var is_playing_main_menu_music: bool = false
var is_playing_in_game_music: bool = false

func ready() -> void:
	start_main_menu_music()
	
func start_main_menu_music():
	is_playing_main_menu_music = true
	is_playing_in_game_music = false
	_on_finished()

func start_in_game_music():
	is_playing_main_menu_music = false
	is_playing_in_game_music = true
	_on_finished()

func _on_finished() -> void:
	if is_playing_main_menu_music and stream != main_menu_music:
		stream = main_menu_music
		play(0.0)
	if is_playing_in_game_music and stream != in_game_music:
		stream = in_game_music
		play(0.0)
	if stream_paused:
		if is_playing_in_game_music:
			play()
		if is_playing_main_menu_music:
			play()
