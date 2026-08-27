class_name SliderClass
extends HSlider

@export var min_sound_interval: float = 0.1 
var _last_sound_time: float = 0.0

func _ready() -> void:
	value_changed.connect(_play_changing_sound)
	drag_ended.connect(_drag_ended_sound)

func _play_changing_sound(_new_value: float) -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - _last_sound_time >= min_sound_interval:
		SoundeffectsManager.play_sound(SoundeffectsManager.button_hovered_sound)
		_last_sound_time = current_time

func _drag_ended_sound(_value_changed: bool) -> void:
	SoundeffectsManager.play_sound(SoundeffectsManager.button_pressed_sound)
