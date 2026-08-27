extends Node2D

@export var enemy_scene: PackedScene
@export var npc_scene: PackedScene

@export var waypoints1: Node2D
@export var waypoints2: Node2D
@export var waypoints3: Node2D

@export var num_of_enemies: int
@export var num_of_npcs: int

@export var king: CharacterBody2D

var used_spawn_points: Array[Vector2]

func _ready() -> void:
	for x in range(num_of_enemies):
		if enemy_scene:
			var enemy_instance = enemy_scene.instantiate()
			enemy_instance.waypoint_container = get(str("waypoints", (x % 3) + 1))
			add_child(enemy_instance)
			
			enemy_instance.position = generate_position()

		else:
			push_error("enemy Scene is missing in spawner")
	
	for x in range(num_of_npcs):
		if npc_scene:
			var npc_instance = enemy_scene.instantiate()
			npc_instance.waypoint_container = get(str("waypoints", (x % 3) + 1))
			add_child(npc_instance)
			
			npc_instance.position = generate_position()
		else:
			push_error("npc Scene is missing in spawner")
			
func generate_position():
	

	var spawn_pos = Vector2(
		randi_range(-30000, 30000),
		randi_range(-30000, 30000)
	)
	print(spawn_pos)
	print(king.position)
	print(spawn_pos.distance_to(king.position))
	
	while spawn_pos.distance_to(king.position) < 1500:
		spawn_pos = Vector2(
			randi_range(0, 100),
			randi_range(0, 100)
		)
	return spawn_pos
