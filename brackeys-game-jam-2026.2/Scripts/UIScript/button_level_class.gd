extends ButtonClass

@export var level_name: String = "Level"
@export var style_locked: StyleBox
@export var style_unlocked: StyleBox
@export var style_cleared: StyleBox

func update_level_status() -> void:
	if Global.cleared_levels.has(level_name):
		disabled = false
		if style_cleared:
			add_theme_stylebox_override("normal", style_cleared)
			add_theme_stylebox_override("hover", style_cleared)
	elif Global.unlocked_levels.has(level_name):
		disabled = false
		if style_unlocked:
			add_theme_stylebox_override("normal", style_unlocked)
	else:
		disabled = true
		if style_locked:
			add_theme_stylebox_override("disabled", style_locked)
