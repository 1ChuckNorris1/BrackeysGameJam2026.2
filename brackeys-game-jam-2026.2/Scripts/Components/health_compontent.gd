extends Node2D

@export var max_lifes = 3

var lifes = max_lifes
var is_alive = true

func take_damage(damage: float):
	
	lifes -= damage
	
	if lifes <= 0:
		on_zero_lifes()


func on_zero_lifes():
	
	is_alive = false
