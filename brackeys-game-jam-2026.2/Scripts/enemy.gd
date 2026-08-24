extends Agent



var target_to_follow: Node2D = null

func prepare():
	var costume_num = Global.free_costumes.pick_random()
	Global.free_costumes.erase(costume_num)
	print("Chose this costume:", costume_num)
	print(Global.free_costumes)
	animated_sprite_2d.play(str(costume_num))

func abilities():
	if target_to_follow != null:
		make_path(target_to_follow.global_position)
		
func _on_controlled_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("King"):
		target_to_follow = body
		speed = 200
		is_chasing = true

func _on_murder_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("King"):
		body.take_damage()

func take_damage():
	call_deferred("queue_free")
