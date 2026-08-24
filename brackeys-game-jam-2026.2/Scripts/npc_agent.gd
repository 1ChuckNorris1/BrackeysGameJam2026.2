extends CharacterBody2D


@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

@export var speed = 300.0
@export var waypoint_container: Node2D

var waypoints: Array[Node]
var waypoint_index = 0

var now_waypoint: Node2D

func _ready():
	for waypoint in waypoint_container.get_children():
		if waypoint is Marker2D:
			waypoints.append(waypoint)
	nav_agent.navigation_finished.connect(_on_nav_finished)
	nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	call_deferred("_on_nav_finished")
	
func _physics_process(_delta: float) -> void:
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	var new_velocity = direction * speed 
	
	nav_agent.velocity = new_velocity

func _on_nav_finished():
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
