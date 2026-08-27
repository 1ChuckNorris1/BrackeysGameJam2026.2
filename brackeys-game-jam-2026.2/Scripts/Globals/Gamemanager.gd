extends Node

const LOOSE_SCREEN = preload("uid://c53rl3w41neas")
const VICTORY_SCREEN = preload("uid://cfys1q7wjueic")
const PLAYTHROUGH_SCREEN = preload("res://Scenes/Menu_UI/beatGameScreen.tscn")
var shake_strength: float = 0.0
var shake_decay: float = 15.0

func _process(delta: float) -> void:
	if shake_strength > 0:
		var camera = get_viewport().get_camera_2d()
		if camera:
			shake_strength = move_toward(shake_strength, 0.0, shake_decay * delta)
			camera.offset = Vector2(
				randf_range(-shake_strength, shake_strength),
				randf_range(-shake_strength, shake_strength)
			)
			if shake_strength <= 0:
				camera.offset = Vector2.ZERO

func screen_shake(strength: float = 10.0, decay: float = 15.0) -> void:
	shake_strength = strength
	shake_decay = decay

func loose_game():
	
	Global.reset_costumes()
	get_tree().change_scene_to_packed(LOOSE_SCREEN)
	

func win_game(level_name: String):
	if Global.win_level(level_name):
		Global.reset_costumes()
		get_tree().change_scene_to_packed(PLAYTHROUGH_SCREEN)
		return
	Global.reset_costumes()
	get_tree().change_scene_to_packed(VICTORY_SCREEN)
