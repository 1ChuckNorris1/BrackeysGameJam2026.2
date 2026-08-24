class_name ButtonClass extends Button

@export var link: PackedScene




func _ready() -> void:
	pressed.connect(_change_to_next_scene)
	update_level_status()

func update_level_status():
	pass

func _change_to_next_scene():
	if link == null: return
	get_tree().change_scene_to_packed(link)
