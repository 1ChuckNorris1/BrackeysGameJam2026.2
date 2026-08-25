extends Area2D

@export var damage_amount: int = 1


func attack(player_attack: bool) -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("King"):
			body.take_damage(player_attack)
		elif body.is_in_group("Damageable"):
			body.take_damage()
