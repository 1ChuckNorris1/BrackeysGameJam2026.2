extends CharacterBody2D

@export var waypoints: Array[Node2D]
var waypoint_index = 0
var now_waypoint = waypoints[0]
	
	

func move():
	pass
#	print(global_position.direction_to(waypoint.global_position))


	#if global_position.distance_to(waypoint.global_position) > 50:
	#	velocity = global_position.direction_to(waypoint.global_position) * SPEED
	#else:
	#	waypoint = select_other_waypoint()

func select_next_waypoint():
	pass
