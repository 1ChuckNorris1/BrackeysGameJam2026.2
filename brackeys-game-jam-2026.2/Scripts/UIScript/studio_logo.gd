extends CanvasLayer


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export_file("*.tscn") var main_menu: String

func _ready() -> void:
	MenuMusic.stop()
	animation_player.play("open")



func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	_change_to_next_scene()



func _change_to_next_scene():
	if main_menu == null: 
		return
	print("changing scene")
	if main_menu.contains("Castle") or main_menu.contains("Market"):
			MenuMusic.stop()
	get_tree().change_scene_to_file(main_menu)
