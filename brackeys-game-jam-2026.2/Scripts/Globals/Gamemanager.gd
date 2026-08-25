extends Node

const LOOSE_SCREEN = preload("uid://c53rl3w41neas")

func end_game():
	
	Global.reset()
	print("ended game")
	
	get_tree().change_scene_to_packed(LOOSE_SCREEN)
