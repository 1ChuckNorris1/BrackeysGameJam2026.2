extends Agent





func take_damage():
	print("Game Over")
	Gamemanager.end_game()
	queue_free()

func prepare():
	animated_sprite_2d.play("idle")
