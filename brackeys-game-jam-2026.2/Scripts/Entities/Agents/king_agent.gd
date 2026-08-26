extends Agent


@onready var die_sound: AudioStreamPlayer = $DieSound


func prepare():
	animated_sprite_2d.play("idle")


func _on_nav_finished():
	if waypoints.size() <= 0:
		return
	if randf() < wait_chance:
		is_waiting = true
		var wait_time = randf_range(0, max_wait_time)
		await get_tree().create_timer(wait_time).timeout
		is_waiting = false
	if waypoint_index >= waypoints.size():
		win_level()
		return
	var target_waypoint = waypoints[waypoint_index]
	make_path(target_waypoint.global_position)
	waypoint_index += 1

func win_level():
	print("Victory!")
	get_tree().current_scene.win_level()
	
func take_damage(player_attack: bool):
	if player_attack:
		Global.save_death_cause(Global.death_cause.end_game_messages_you_killed_king)
	else:
		Global.save_death_cause(Global.death_cause.end_game_messages_murderer_killed_king)
		
	die()

func die(): 
	is_waiting = true
	die_sound.playing = true
	animated_sprite_2d.play("die")
	
	
func loose_level():
	print("Game Over")
	Gamemanager.loose_game()
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	
	loose_level()
