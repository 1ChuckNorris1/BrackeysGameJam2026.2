extends Node2D

@export var tile_map_layers: Array[TileMapLayer] 
@export var default_surface: String = "gras" 
@onready var marker_2d: Marker2D = $Marker2D
@onready var movement_particles: GPUParticles2D = $GPUParticles2D

const COLOR_GRAS = Color("2d9334")
const COLOR_ERDE = Color("bf7958")

func _process(delta: float) -> void:
	_handle_ground_particles()
	
func start_particles() -> void:
	movement_particles.emitting = true

func stop_particles() -> void:
	movement_particles.emitting = false

func _handle_ground_particles() -> void:
	if not movement_particles.emitting:
		return
		
	var surface: String = get_surface_type()
	var process_mat = movement_particles.process_material as ParticleProcessMaterial
	
	if process_mat:
		match surface.strip_edges().to_lower(): 
			"gras":
				process_mat.color = COLOR_GRAS
			"path":
				process_mat.color = COLOR_ERDE
			_:
				movement_particles.emitting = false

func get_surface_type() -> String:
	var foot_position: Vector2 = marker_2d.global_position
	
	for layer in tile_map_layers:
		if not layer:
			continue
			
		var local_foot_pos: Vector2 = layer.to_local(foot_position)
		var cell_coords: Vector2i = layer.local_to_map(local_foot_pos)
		
		var tile_data: TileData = layer.get_cell_tile_data(cell_coords)
		
		if tile_data:
			var custom_val = tile_data.get_custom_data_by_layer_id(0)
			
			if custom_val != null and str(custom_val).strip_edges() != "":
				return str(custom_val)
				
	return default_surface
