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
	await get_tree().physics_frame
	await NavigationServer2D.map_changed
	await get_tree().create_timer(0.1).timeout
	for child in waypoint_container.get_children():
		child.free()
		
	for i in range(num_of_waypoints):
		var marker = Marker2D.new()
		marker.position = generate_position(false)
		marker.name = "Waypoint_" + str(i)
		waypoint_container.add_child(marker)
		
# Enemies spawnen
	for x in range(num_of_enemies):
		if enemy_scene:
			var enemy_instance = enemy_scene.instantiate()
			enemy_instance.waypoint_container = waypoint_container
			# ERST Position generieren & zuweisen, DANN dem Tree hinzufügen
			enemy_instance.global_position = generate_position(true)
			entities_container.add_child(enemy_instance)
		else:
			push_error("enemy Scene is missing in spawner")
	
	# NPCs spawnen
	for x in range(num_of_npcs):
		if npc_scene:
			var npc_instance = npc_scene.instantiate()
			npc_instance.waypoint_container = waypoint_container
			npc_instance.global_position = generate_position(true)
			entities_container.add_child(npc_instance)
		else:
			push_error("npc Scene is missing in spawner")
	



func generate_position(away_from_king: bool = true) -> Vector2:
	var region_rid = entities_container.get_region_rid()
	var king_pos = king.global_position if king else Vector2.ZERO
	var min_distance = 40.0 
	
	for attempt in range(300):
		var spawn_pos = NavigationServer2D.region_get_random_point(region_rid, 1, true)
		
		if spawn_pos == Vector2.ZERO:
			continue

		if away_from_king and king and spawn_pos.distance_to(king_pos) < 500:
			continue
			
		if is_point_in_obstacle(spawn_pos):
			continue
			
		var too_close = false
		for used_pos in used_spawn_points:
			if spawn_pos.distance_to(used_pos) < min_distance:
				too_close = true
				break
				
		if too_close:
			continue

		used_spawn_points.append(spawn_pos)
		return spawn_pos
		
	push_warning("Keine freie Spawnposition gefunden! Nutze Ausweich-Position.")
	
	# Neu: Sichere Notfall-Position statt Vector2.ZERO
	var fallback = king_pos + Vector2(randf_range(400, 700), randf_range(400, 700))
	used_spawn_points.append(fallback)
	return fallback


func is_point_in_obstacle(pos: Vector2, radius: float = 20.0) -> bool:
	var space_state = get_world_2d().direct_space_state
	
	var shape_query = PhysicsShapeQueryParameters2D.new()
	var circle = CircleShape2D.new()
	circle.radius = radius
	
	shape_query.shape = circle
	shape_query.transform = Transform2D(0.0, pos)
	shape_query.collision_mask = 1
	
	var result = space_state.intersect_shape(shape_query)
	return result.size() > 0
