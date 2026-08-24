extends Control

@onready var fullscreen_check = %FullscreenCheckbox
@onready var resolution_option = %ResolutionOption

var resolutions: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
]

func _ready() -> void:
	if not fullscreen_check.toggled.is_connected(_on_fullscreen_check_toggled):
		fullscreen_check.toggled.connect(_on_fullscreen_check_toggled)
	if not resolution_option.item_selected.is_connected(_on_resolution_option_item_selected):
		resolution_option.item_selected.connect(_on_resolution_option_item_selected)


	resolution_option.clear()
	for res in resolutions:
		resolution_option.add_item("%d x %d" % [res.x, res.y])

	var is_fullscreen = SettingsManager.settings.fullscreen
	fullscreen_check.set_pressed_no_signal(is_fullscreen)
	
	resolution_option.disabled = is_fullscreen
	
	var current_res = SettingsManager.settings.resolution
	var res_index = resolutions.find(current_res)
	if res_index != -1:
		resolution_option.select(res_index)

func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	resolution_option.disabled = toggled_on
	SettingsManager.settings.fullscreen = toggled_on
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_resolution_option_item_selected(index: int) -> void:
	SettingsManager.settings.resolution = resolutions[index]
	SettingsManager.apply_settings()
	SettingsManager.save_settings()
