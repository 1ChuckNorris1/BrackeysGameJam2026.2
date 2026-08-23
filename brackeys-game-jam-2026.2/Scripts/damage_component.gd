extends Area2D

@export var damage_amount: int = 1

func _ready() -> void:
	get_child(0).disabled = true

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Damageable"):
		body.health_component.take_damage(damage_amount)
		
	else:
		push_error("Unexpected body entered the Player hitbox, these are his groups:", body.get_groups(), "and his name:", body.name)

func attack() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("enemy"):
			body.take_damage()
