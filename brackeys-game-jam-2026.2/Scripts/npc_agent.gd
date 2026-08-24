extends Agent

@onready var hit_box: CollisionShape2D = $HitBox
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func take_damage():
	print("Game Over")

func prepare():
	animated_sprite_2d.play(str(randi_range(1,9)))
