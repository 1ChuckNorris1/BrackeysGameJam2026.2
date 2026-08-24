extends Button

func _ready() -> void:
	pressed.connect(quit_game)
	
	
func quit_game() -> void:
	get_tree().quit()
