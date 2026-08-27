extends Agent

@export var attack_speed = 400.0
var target_to_follow: Node2D = null

@onready var death_animation: AnimatedSprite2D = %DeathAnimation
@onready var die_sound: AudioStreamPlayer = $DieSound

var target_update_timer: float = 0.0
var rand_costum_num: int = 1
func prepare():
	if Global.free_costumes.size() > 0:
		if Global.enemy_costumes.size() < Global.all_costumes.size() / 2:
			var costume_num = Global.free_costumes.pick_random()
			Global.free_costumes.erase(costume_num)
			animated_sprite_2d.play(str(costume_num))
			Global.enemy_costumes.append(costume_num)
			rand_costum_num = costume_num
		else:
			var costume_num = Global.enemy_costumes.pick_random()
			animated_sprite_2d.play(str(costume_num))
			rand_costum_num = costume_num
	else: 
		animated_sprite_2d.play("1")
		rand_costum_num = 1

func abilities():
	if is_chasing and is_instance_valid(target_to_follow):
		# Pfad nicht jeden Frame aktualisieren, sondern alle 0.1 Sekunden
		target_update_timer -= get_physics_process_delta_time()
		if target_update_timer <= 0.0:
			target_update_timer = 0.1
			make_path(target_to_follow.global_position)

func _on_controlled_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("King"):
		target_to_follow = body
		speed = attack_speed
		is_chasing = true
		is_waiting = false
		make_path(target_to_follow.global_position)

func _on_murder_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("King"):
		body.take_damage(false)

func _on_nav_finished():
	if is_chasing:
		return 
	super._on_nav_finished()

func take_damage():
	Global.statistics["Murderer Deaths"] += 1
	Global.enemy_costumes.erase(rand_costum_num)
	die()

func die():
	is_waiting = true
	is_chasing = false
	death_animation.visible = true
	die_sound.playing = true
	death_animation.play("die")

func delete_self():
	call_deferred("queue_free")
