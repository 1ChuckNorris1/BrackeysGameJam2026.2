extends HBoxContainer


@onready var image_container: Control = $Image

func _ready() -> void:
	await NavigationServer2D.map_changed
	await get_tree().process_frame
	for enemy in Global.enemy_costumes:
		show_image(enemy)
	image_container.queue_free()
	
func show_image(number: int) -> void:
	var image = image_container.duplicate() as Control
	add_child(image)
	
	var animated_sprite = image.get_child(0) as AnimatedSprite2D
	animated_sprite.animation = str(number)
	animated_sprite.frame = 0
	animated_sprite.stop()

	
	
