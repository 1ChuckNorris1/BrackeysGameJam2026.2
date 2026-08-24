extends Area2D

@export var damage_amount: int = 1


func attack() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("Damageable"):
			body.take_damage()
