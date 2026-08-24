class_name ButtonClass extends Button

@export var link: PackedScene
@export var level_name: String = "Level"


func _ready() -> void:
	text = level_name
	if Global.cleared_levels.has(level_name):
		
	pressed.connect(_change_to_next_scene)
	
	
func _change_to_next_scene():
	if link == null: return
	get_tree().change_scene_to_packed(link)
