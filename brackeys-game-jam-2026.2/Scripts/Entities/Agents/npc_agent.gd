extends Agent

@onready var die_sound: AudioStreamPlayer = $DieSound
@onready var death_animation: AnimatedSprite2D = %DeathAnimation



func take_damage():
	die()

func die():
	is_waiting = true
	death_animation.visible = true
	die_sound.playing = true
	death_animation.play("die")
	
func prepare():
	if Global.free_costumes.size() > 0:
		var costume_num = Global.free_costumes.pick_random()
	#	print("Chose this costume:", costume_num)
		Global.free_costumes.erase(costume_num)
	#	print(Global.free_costumes)
		animated_sprite_2d.play(str(costume_num))
	else: 
		animated_sprite_2d.play("1")

func loose_level():
	print("Game Over")
	Global.save_death_cause(Global.death_cause.end_game_messages_you_killed_npc)
	Gamemanager.loose_game()
	queue_free()
