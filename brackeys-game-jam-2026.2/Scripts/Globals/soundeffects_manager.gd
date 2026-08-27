extends AudioStreamPlayer

@export var button_pressed_sound: AudioStream = preload("res://assets/Sounds/MenuSounds/button_press.wav")
@export var button_hovered_sound: AudioStream = preload("res://assets/Sounds/MenuSounds/button_hover.wav")
@export var game_start_sound: AudioStream = preload("res://assets/Sounds/MenuSounds/game_start.wav")
@export var wanted_sign_sound: AudioStream = preload("res://assets/Sounds/MenuSounds/papier_moerder_liste.wav")
@export var victory_screen_sound: AudioStream = preload("res://assets/Sounds/MenuSounds/win-sound.wav")

func play_sound(sound_type: AudioStream):
	var stream_to_play = sound_type
	if stream_to_play:
		stream = stream_to_play
		play()
		
