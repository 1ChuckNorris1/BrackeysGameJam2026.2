extends Agent


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
		win_game()
		return
	var target_waypoint = waypoints[waypoint_index]
	make_path(target_waypoint.global_position)
	waypoint_index += 1

func win_game():
	print("Victory!")

func take_damage():
	print("Game Over")
	Gamemanager.end_game()
	queue_free()
