class_name SpawnerClass
extends Node2D

@export var enemy_scene: PackedScene
@export var npc_scene: PackedScene

@export var entities_container: NavigationRegion2D
@export var waypoint_container: Node2D
@export var num_of_waypoints: int = 40

@export var tile_map_layers: TileMapLayer

@export var num_of_enemies: int
@export var num_of_npcs: int

@export var king: CharacterBody2D

var used_spawn_points: Array[Vector2]

func _ready() -> void:
	await NavigationServer2D.map_changed
	for child in waypoint_container.get_children():
		child.free()
		
	for i in range(num_of_waypoints):
		var marker = Marker2D.new()
		marker.position = generate_position(false)
		marker.name = "Waypoint_" + str(i)
		waypoint_container.add_child(marker)
		
	for x in range(num_of_enemies):
		if enemy_scene:
			var enemy_instance = enemy_scene.instantiate()
			enemy_instance.waypoint_container = waypoint_container
			entities_container.add_child(enemy_instance)

			enemy_instance.position = generate_position()

		else:
			push_error("enemy Scene is missing in spawner")
	
	for x in range(num_of_npcs):
		if npc_scene:
			var npc_instance = npc_scene.instantiate()
			npc_instance.waypoint_container = waypoint_container
			entities_container.add_child(npc_instance)
			
			npc_instance.position = generate_position()
		else:
			push_error("npc Scene is missing in spawner")
	

		

	

			
func generate_position(away_from_king: bool = true):
	var region_rid = entities_container.get_region_rid()
	var spawn_pos = NavigationServer2D.region_get_random_point(region_rid,1,true)
	var king_pos = king.global_position if king else Vector2.ZERO
	if away_from_king:
		while spawn_pos.distance_to(king_pos) < 500:
			spawn_pos = NavigationServer2D.region_get_random_point(region_rid, 1 ,true)
	
	return spawn_pos
