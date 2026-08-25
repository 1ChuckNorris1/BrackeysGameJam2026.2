extends CharacterBody2D


const SPEED = 300.0

@export var tile_map_layers: Array[TileMapLayer]

@onready var animated_sprite: AnimatedSprite2D = $"AnimatedSprite2D"
@onready var attack_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var damage_component: Area2D = $Damage_component
@onready var movement_particles_component: Node2D = %MovementParticlesComponent

var is_moving: bool = false

var damage_component_offset: Vector2
var last_direction: Vector2 = Vector2.RIGHT
var is_attacking: bool = false
var damage = 1
var is_dead: bool = false

func _ready() -> void:
	movement_particles_component.tile_map_layers = tile_map_layers
	# init hitbox offset
	damage_component_offset = damage_component.position

func _process(_delta: float) -> void:
	if is_moving:
		movement_particles_component.start_particles()
	else:
		movement_particles_component.stop_particles()
		

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("attack") and !is_attacking:
		attack()
		
	if is_attacking:
		velocity = Vector2.ZERO
		return
	
	process_movement()
	process_animation()
	move_and_slide()


func process_movement():
	
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		is_moving = true
		last_direction = direction
		velocity = direction * SPEED
		
	else:
		is_moving = false
		velocity = Vector2.ZERO

#-----------------------------------------------------------------------------------
#  MOVEMENT & ANIMATION
#-----------------------------------------------------------------------------------

func process_animation():
	
	if velocity != Vector2.ZERO:
		play_animation("run", last_direction)
		
	else:
		play_animation("idle", last_direction)


func play_animation(prefix: String, dir: Vector2):
	
	var x := damage_component_offset.x
	var y := damage_component_offset.y
	
	if dir.x != 0:
		
		animated_sprite.flip_h = dir.x < 0
		animated_sprite.play(prefix + "_right")
		if animated_sprite.flip_h:
			damage_component.position = Vector2(-x,y)
		else:
			damage_component.position = Vector2(x,y)
		
	elif dir.y < 0:
		animated_sprite.play(prefix + "_up")
		damage_component.position = Vector2(y,-x)
		
	elif dir.y > 0:
		animated_sprite.play(prefix + "_down")
		damage_component.position = Vector2(-y,x)

#-----------------------------------------------------------------------------------
#  ATTACKING
#-----------------------------------------------------------------------------------

func attack():
	is_attacking = true
	damage_component.attack(true)
	attack_stream_player.play()
	play_animation("attack", last_direction)


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_attacking:
		is_attacking = false
		damage_component.get_child(0).disabled = true
	elif is_dead:
		queue_free()
