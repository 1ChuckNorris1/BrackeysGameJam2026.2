extends Agent


func _on_controlled_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("King"):
		speed = 400
		make_path(body.global_position)

func _on_murder_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("King"):
		print("Game Over")
