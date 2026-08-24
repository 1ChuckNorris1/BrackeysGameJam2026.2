extends Agent





func take_damage():
	print("Game Over")
	queue_free()

func prepare():
	animated_sprite_2d.play(str(randi_range(1,15)))
