extends Agent


func take_damage():
	print("Game Over")
	queue_free()

func prepare():
	var costume_num = Global.free_costumes.pick_random()
	Global.free_costumes.erase(costume_num)
	print(Global.free_costumes)
	animated_sprite_2d.play(str(costume_num))
	
