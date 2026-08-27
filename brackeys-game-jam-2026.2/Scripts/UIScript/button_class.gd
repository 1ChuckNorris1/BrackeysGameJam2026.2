class_name ButtonClass extends Button

@export_file("*.tscn") var scene_path: String



func _ready() -> void:
	pressed.connect(_change_to_next_scene)
	mouse_entered.connect(SoundeffectsManager.play_sound.bind(SoundeffectsManager.button_hovered_sound))
	update_level_status()

func update_level_status():
	pass

func _change_to_next_scene():
	SoundeffectsManager.play_sound(SoundeffectsManager.button_pressed_sound)
	if scene_path == null: 
		return
	print("changing scene")
	if scene_path.contains("Castle") or scene_path.contains("Market"):
			MenuMusic.stop()
	get_tree().change_scene_to_file(scene_path)
