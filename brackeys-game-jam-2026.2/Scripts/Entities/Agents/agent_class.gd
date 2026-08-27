class_name Agent
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var movement_particles: Node2D = %MovementParticlesComponent

@export var tile_map_layers: Array[TileMapLayer]
@export var base_speed: float = 75.0
var speed: float

@export var waypoint_container: Node2D

@export_group("Lauf Animation")
@export var wackel_speed: float = 10.0    
@export var wackel_winkel: float = 7.0  
@export var sprung_hoehe: float = 2.0       

var wackel_time: float = 0.0

@export_group("Waiting")
var is_waiting: bool = false
@export var wait_chance: float = 0.5    
@export var max_wait_time: float = 3.0 
@export var waypoint_radius: float = 75.0

var waypoints: Array[Node]
var waypoint_index = 0
var now_waypoint: Node2D

var is_chasing: bool = false

var last_position: Vector2 = Vector2.ZERO
var stuck_timer: float = 0.0

func _ready():
	nav_agent.target_desired_distance = waypoint_radius
	movement_particles.tile_map_layers = tile_map_layers
	speed = base_speed
	for waypoint in waypoint_container.get_children():
		if waypoint is Marker2D:
			waypoints.append(waypoint)
	nav_agent.navigation_finished.connect(_on_nav_finished)
	nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	prepare()
	call_deferred("_on_nav_finished")
	await get_tree().process_frame
	animated_sprite_2d.frame = 0
	animated_sprite_2d.stop()
	
func prepare():
	pass

func _physics_process(delta: float) -> void:
	if is_chasing: 
		is_waiting = false
		
	if is_waiting: 
		movement_particles.stop_particles()
		nav_agent.velocity = Vector2.ZERO
		velocity = velocity.move_toward(Vector2.ZERO, 100)
		move_and_slide()
		handle_wackeln(delta)
		return
	else:
		movement_particles.start_particles()


	if nav_agent.is_navigation_finished():
		return

	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	var target_velocity = direction * speed 
	

	if nav_agent.avoidance_enabled:
		nav_agent.velocity = target_velocity
	else:
		_on_navigation_agent_2d_velocity_computed(target_velocity)
		
	abilities()
	handle_wackeln(delta)
	
	if not is_waiting and velocity.length() > 5.0:
		if global_position.distance_to(last_position) < 2.0:
			stuck_timer += delta
			if stuck_timer > 2.0: 
				stuck_timer = 0.0
				_on_nav_finished()
		else:
			stuck_timer = 0.0
			last_position = global_position
	
func _process(_delta: float) -> void:
	var speed_randomizer = randf_range(0,3000)
	if speed_randomizer > 2999:
		if speed < base_speed + 50:
			speed += 20
	elif speed_randomizer < 1:
		if speed > base_speed - 50:
			speed -= 20
	
func abilities():
	pass

func _on_nav_finished():
	if is_chasing or waypoints.size() <= 0: return
	if randf() < wait_chance:
		is_waiting = true
		var wait_time = randf_range(0, max_wait_time)
		await get_tree().create_timer(wait_time).timeout
		is_waiting = false
	var new_position = select_next_waypoint().global_position
	make_path(new_position)
	
func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 100)
	move_and_slide()
	
func make_path(pos: Vector2):
	nav_agent.target_position = pos

func select_next_waypoint() -> Marker2D:
	waypoint_index = randi_range(0, waypoints.size()-1)
	return waypoints[waypoint_index]
	
func handle_wackeln(delta: float) -> void:
	if animated_sprite_2d == null: return

	if velocity.length() > 10.0:
		wackel_time += delta * wackel_speed
		animated_sprite_2d.rotation_degrees = sin(wackel_time) * wackel_winkel
		animated_sprite_2d.position.y = -abs(sin(wackel_time)) * sprung_hoehe
	else:
		wackel_time = 0.0
		animated_sprite_2d.rotation_degrees = move_toward(animated_sprite_2d.rotation_degrees, 0.0, delta * 100.0)
		animated_sprite_2d.position.y = move_toward(animated_sprite_2d.position.y, 0.0, delta * 50.0)
