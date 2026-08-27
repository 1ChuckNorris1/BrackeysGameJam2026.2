class_name LevelClass
extends Node2D

@onready var quit_button: Button = %QuitButton
@onready var wanted_sign: CanvasLayer = %WantedSign
@onready var screen_end_level: CanvasLayer = %Screen_end_level

@onready var canvas_layer: CanvasLayer = %WantedSign
@export var level_name:String = "Castle1"

var level_won: bool = false
func _ready() -> void:
	level_won = false
	wanted_sign.deleted_wanted_sign.connect(_on_button_pressed)
	get_tree().paused = true
	SoundeffectsManager.play_sound(SoundeffectsManager.wanted_sign_sound)
	
func _process(_delta: float) -> void:
	if Global.enemy_costumes.is_empty() and level_won == false:
		screen_end_level.show_button()
		level_won = true
	
func _on_button_pressed() -> void:
	MenuMusic.start_in_game_music()
	get_tree().paused = false
	canvas_layer.queue_free()

func win_level():
	Gamemanager.win_game(level_name)
