extends AudioStreamPlayer

@export var button_pressed_sound = preload("res://assets/Sounds/MenuSounds/Menu_Sounds_V2_byNoahKuehne_wav DIST/Minimalistic/Menu_Sounds_V2_Minimalistic_HOVER.wav")
@export var button_hovered_sound = preload("res://assets/Sounds/MenuSounds/Menu_Sounds_V2_byNoahKuehne_wav DIST/Minimalistic/Menu_Sounds_V2_Minimalistic_HOVER.wav")


func play_sound(sound_type: String):
	var stream_to_play = sound_type
	if stream_to_play:
		stream = stream_to_play
		play()
		
