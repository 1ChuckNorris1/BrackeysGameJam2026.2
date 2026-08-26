extends Agent

@onready var die_sound: AudioStreamPlayer = $DieSound
@onready var death_animation: AnimatedSprite2D = %DeathAnimation



func take_damage():
	die()

func die():
	Gamemanager.screen_shake()
	is_waiting = true
	death_animation.visible = true
	die_sound.playing = true
	death_animation.play("die")
	
func prepare():
	await get_tree().process_frame
	if Global.free_costumes.size() > 0:
		var costume_num = Global.free_costumes.pick_random()
		Global.free_costumes.erase(costume_num)
		animated_sprite_2d.play(str(costume_num))
		return
		
		#falls es mehr als 40 costume braucht:
	var allowed_costumes = Global.all_costumes.filter(
		func(c): return c not in Global.enemy_costumes
		)

	if not allowed_costumes.is_empty():
		var costume_num = allowed_costumes.pick_random()
		animated_sprite_2d.play(str(costume_num))
	else:
		animated_sprite_2d.play("1")


func loose_level():
	print("Game Over")
	Global.save_death_cause(Global.death_cause.end_game_messages_you_killed_npc)
	Gamemanager.loose_game()
	queue_free()
