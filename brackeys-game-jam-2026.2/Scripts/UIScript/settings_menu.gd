extends Control

@onready var fullscreen_check: CheckBox = %FullscreenCheckbox
@onready var resolution_option: OptionButton = %ResolutionOption

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider

var resolutions: Array[Vector2i] = [
	Vector2i(1280, 720),   
	Vector2i(1920, 1080),  
	Vector2i(2560, 1440)  
]

func _ready() -> void:
	_connect_signals()
	_populate_resolution_options()
	_load_ui_states()

func _connect_signals() -> void:
	if not fullscreen_check.toggled.is_connected(_on_fullscreen_check_toggled):
		fullscreen_check.toggled.connect(_on_fullscreen_check_toggled)
	if not resolution_option.item_selected.is_connected(_on_resolution_option_item_selected):
		resolution_option.item_selected.connect(_on_resolution_option_item_selected)


	if not master_slider.value_changed.is_connected(_on_master_slider_value_changed):
		master_slider.value_changed.connect(_on_master_slider_value_changed)
	if not music_slider.value_changed.is_connected(_on_music_slider_value_changed):
		music_slider.value_changed.connect(_on_music_slider_value_changed)
	if not sfx_slider.value_changed.is_connected(_on_sfx_slider_value_changed):
		sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)

func _populate_resolution_options() -> void:
	resolution_option.clear()
	var base_width: int = ProjectSettings.get_setting("display/window/size/viewport_width", 640)
	
	for res in resolutions:
		var scale_factor: int = res.x / base_width
		resolution_option.add_item("%d x %d (%dx)" % [res.x, res.y, scale_factor])

func _load_ui_states() -> void:
	var is_fullscreen: bool = SettingsManager.settings.fullscreen
	fullscreen_check.set_pressed_no_signal(is_fullscreen)
	resolution_option.disabled = is_fullscreen
	
	if get_window().is_embedded():
		fullscreen_check.disabled = true
		fullscreen_check.tooltip_text = "Vollbild in eingebetteten Fenstern nicht verfügbar"

	var current_res: Vector2i = SettingsManager.settings.resolution
	var res_index: int = resolutions.find(current_res)
	
	if res_index != -1:
		resolution_option.select(res_index)
	else:
		resolution_option.select(0)
		SettingsManager.settings.resolution = resolutions[0]


	master_slider.set_value_no_signal(SettingsManager.settings.get("master_volume", 1.0))
	music_slider.set_value_no_signal(SettingsManager.settings.get("music_volume", 1.0))
	sfx_slider.set_value_no_signal(SettingsManager.settings.get("sfx_volume", 1.0))


func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	if get_window().is_embedded():
		return
		
	resolution_option.disabled = toggled_on
	SettingsManager.settings.fullscreen = toggled_on
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_resolution_option_item_selected(index: int) -> void:
	SettingsManager.settings.resolution = resolutions[index]
	SettingsManager.apply_settings()
	SettingsManager.save_settings()


func _on_master_slider_value_changed(value: float) -> void:
	SettingsManager.settings.master_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_music_slider_value_changed(value: float) -> void:
	SettingsManager.settings.music_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsManager.settings.sfx_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()
