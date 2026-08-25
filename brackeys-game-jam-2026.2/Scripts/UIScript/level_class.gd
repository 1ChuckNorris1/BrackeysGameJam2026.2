class_name LevelClass
extends Node2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@export var level_name:String = "Level"

func _ready() -> void:
	get_tree().paused = true
	
	
func _on_button_pressed() -> void:
	get_tree().paused = false
	canvas_layer.queue_free()

func win_level():
	Gamemanager.win_game(level_name)
