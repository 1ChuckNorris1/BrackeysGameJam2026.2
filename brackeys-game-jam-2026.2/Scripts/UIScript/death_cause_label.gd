extends Label

func _ready() -> void:
	text = Global.get_random_death_message()
