extends Agent


func take_damage():
	die()

func die():
	is_waiting = true
	die_animation.visible = true
	die_animation.play("die")
	
func prepare():
	if Global.free_costumes.size() > 0:
		var costume_num = Global.free_costumes.pick_random()
		print("Chose this costume:", costume_num)
		Global.free_costumes.erase(costume_num)
		print(Global.free_costumes)
		animated_sprite_2d.play(str(costume_num))
	else: 
		animated_sprite_2d.play("1")

func loose_level():
	print("Game Over")
	Gamemanager.loose_game()
	queue_free()
