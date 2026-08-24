class_name Agent
extends CharacterBody2D


@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

@export var base_speed: float = 100.0
var speed: float
@export var min_speed: float = 50.0
@export var max_speed: float = 150.0

@export var waypoint_container: Node2D

var waypoints: Array[Node]
var waypoint_index = 0

var now_waypoint: Node2D

var is_chasing: bool = false

func _ready():
	speed = base_speed
	for waypoint in waypoint_container.get_children():
		if waypoint is Marker2D:
			waypoints.append(waypoint)
	nav_agent.navigation_finished.connect(_on_nav_finished)
	nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	prepare()
	call_deferred("_on_nav_finished")
	
func prepare():
	pass

func _physics_process(_delta: float) -> void:
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	var new_velocity = direction * speed 
	
	nav_agent.velocity = new_velocity
	abilities()
	
func _process(_delta: float) -> void:
	var speed_randomizer = randf_range(0,3000)
	if speed_randomizer > 2999:
		if speed < max_speed:
			speed += 20
	elif speed_randomizer < 1:
		if speed > min_speed:
			speed -= 20
	
func abilities():
	pass

func _on_nav_finished():
	if is_chasing or waypoints.size() <= 0: return
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
