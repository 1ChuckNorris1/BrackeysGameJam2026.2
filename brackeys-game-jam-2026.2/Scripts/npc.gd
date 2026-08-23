extends CharacterBody2D

const SPEED = 300

@export var waypoint_container: Node2D

var waypoints: Array[Node]
var waypoint_index = 0

var now_waypoint: Node2D
	
func _ready() -> void:
	waypoints = waypoint_container.get_children()
	now_waypoint = waypoints[0]
	
func _physics_process(_delta: float) -> void:
	process_movement()
	move_and_slide()	

func process_movement():

#	print(global_position.direction_to(waypoint.global_position))

	if position.distance_to(now_waypoint.position) > 10:
	
		velocity = global_position.direction_to(now_waypoint.global_position) * SPEED
	else:
#		print("new waypoint")
		now_waypoint = select_next_waypoint()

func select_next_waypoint():
	waypoint_index += 1
	return waypoints[waypoint_index % (len(waypoints) - 1)]
