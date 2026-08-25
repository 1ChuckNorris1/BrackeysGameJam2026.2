extends Agent


@export var attack_speed = 400.0
var target_to_follow: Node2D = null


func prepare():
	if Global.free_costumes.size() > 0:
		var costume_num = Global.free_costumes.pick_random()
		print("Chose this costume:", costume_num)
		Global.free_costumes.erase(costume_num)
		print(Global.free_costumes)
		animated_sprite_2d.play(str(costume_num))
		Global.enemy_costumes.append(costume_num)
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
	die()



func die():
	is_waiting = true
	is_chasing = false
	die_animation.visible = true
	die_animation.play("die")
	
func delete_self():
	call_deferred("queue_free")
