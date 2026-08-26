class_name ButtonClass extends Button

@export_file("*.tscn") var scene_path: String

func _ready() -> void:
	pressed.connect(_change_to_next_scene)
	update_level_status()

func update_level_status():
	pass

func _change_to_next_scene():
	if scene_path == null: 
		return
	print("changing scene")
	if scene_path.contains("Castle") or scene_path.contains("Market"):
			MenuMusic.stop()
	get_tree().change_scene_to_file(scene_path)
