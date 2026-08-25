extends Node

const LOOSE_SCREEN = preload("uid://c53rl3w41neas")
const VICTORY_SCREEN = preload("uid://cfys1q7wjueic")


func loose_game():
	Global.reset()
	get_tree().change_scene_to_packed(LOOSE_SCREEN)

func win_game(level_name: String):
	Global.win_level(level_name)
	Global.reset_costumes()
	get_tree().change_scene_to_packed(VICTORY_SCREEN)
