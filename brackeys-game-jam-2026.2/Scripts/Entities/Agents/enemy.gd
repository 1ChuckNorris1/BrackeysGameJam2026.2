extends Agent


@export var attack_speed = 300.0
var target_to_follow: Node2D = null

@onready var death_animation: AnimatedSprite2D = %DeathAnimation
@onready var die_sound: AudioStreamPlayer = $DieSound


func prepare():
	if Global.free_costumes.size() > 0:
		if Global.enemy_costumes.size() < Global.all_costumes.size() / 2:
			var costume_num = Global.free_costumes.pick_random()
	#		print("Chose this costume:", costume_num)
			Global.free_costumes.erase(costume_num)
	#		print(Global.free_costumes)
			animated_sprite_2d.play(str(costume_num))
			Global.enemy_costumes.append(costume_num)
		else:
			var costume_num = Global.enemy_costumes.pick_random()
			animated_sprite_2d.play(str(costume_num))
		
	else: 
		animated_sprite_2d.play("1")

func abilities():
	if target_to_follow != null:
		make_path(target_to_follow.global_position)
		
func _on_controlled_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("King"):
		target_to_follow = body
		speed = attack_speed
		is_chasing = true

func _on_murder_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("King"):
		body.take_damage(false)

func take_damage():
	Global.statistics["Murderer Deaths"] += 1
	die()



func die():
	is_waiting = true
	is_chasing = false
	death_animation.visible = true
	die_sound.playing = true
	death_animation.play("die")
	
func delete_self():
	call_deferred("queue_free")
