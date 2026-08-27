class_name LevelClass
extends Node2D

@onready var quit_button: Button = %QuitButton

@onready var canvas_layer: CanvasLayer = %WantedSign
@export var level_name:String = "Castle1"

func _ready() -> void:
	get_tree().paused = true
	quit_button.pressed.connect(_on_button_pressed)
	MenuMusic.stop_music()
	
	
func _on_button_pressed() -> void:
	get_tree().paused = false
	canvas_layer.queue_free()

func win_level():
	Gamemanager.win_game(level_name)
