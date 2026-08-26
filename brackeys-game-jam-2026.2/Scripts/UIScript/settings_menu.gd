extends Control

@onready var fullscreen_check: CheckBox = %FullscreenCheckbox
@onready var resolution_option: OptionButton = %ResolutionOption

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider

@onready var keybind_list: VBoxContainer = %KeybindList
@onready var stats_container: VBoxContainer = %StatsContainer

var action_to_rebind: String = ""
var slot_to_rebind: int = 0 
var rebind_button_reference: Button = null

const RESOLUTIONS: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
]

func _ready() -> void:
	_populate_resolution_options()
	_load_ui_states()
	_connect_signals()
	_generate_keybind_ui()
	_generate_stats_ui()

func _connect_signals() -> void:
	fullscreen_check.toggled.connect(_on_fullscreen_check_toggled)
	resolution_option.item_selected.connect(_on_resolution_option_item_selected)

	master_slider.value_changed.connect(func(val): _on_volume_changed("master_volume", val))
	music_slider.value_changed.connect(func(val): _on_volume_changed("music_volume", val))
	sfx_slider.value_changed.connect(func(val): _on_volume_changed("sfx_volume", val))

	master_slider.drag_ended.connect(func(_changed): SettingsManager.save_settings())
	music_slider.drag_ended.connect(func(_changed): SettingsManager.save_settings())
	sfx_slider.drag_ended.connect(func(_changed): SettingsManager.save_settings())

func _populate_resolution_options() -> void:
	resolution_option.clear()
	var base_width: float = ProjectSettings.get_setting("display/window/size/viewport_width", 1280)
	
	for res in RESOLUTIONS:
		var scale_factor: float = res.x / base_width
		resolution_option.add_item("%d x %d (%.1fx)" % [res.x, res.y, scale_factor])

func _load_ui_states() -> void:
	var settings = SettingsManager.settings
	
	var is_fullscreen: bool = settings.get("fullscreen", false)
	fullscreen_check.set_pressed_no_signal(is_fullscreen)
	resolution_option.disabled = is_fullscreen
	
	if get_window().is_embedded():
		fullscreen_check.disabled = true
		fullscreen_check.tooltip_text = "Vollbild in eingebetteten Fenstern nicht verfügbar"

	var current_res: Vector2i = settings.get("resolution", RESOLUTIONS[0])
	var res_index: int = RESOLUTIONS.find(current_res)
	
	if res_index != -1:
		resolution_option.select(res_index)
	else:
		resolution_option.select(0)
		settings.resolution = RESOLUTIONS[0]

	master_slider.set_value_no_signal(settings.get("master_volume", 1.0))
	music_slider.set_value_no_signal(settings.get("music_volume", 1.0))
	sfx_slider.set_value_no_signal(settings.get("sfx_volume", 1.0))

func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	if get_window().is_embedded():
		return
	resolution_option.disabled = toggled_on
	SettingsManager.settings.fullscreen = toggled_on
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_resolution_option_item_selected(index: int) -> void:
	SettingsManager.settings.resolution = RESOLUTIONS[index]
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_volume_changed(setting_key: String, value: float) -> void:
	SettingsManager.settings[setting_key] = value
	SettingsManager.apply_settings()

func _generate_stats_ui() -> void:
	for child in stats_container.get_children():
		child.queue_free()
	
	for key in Global.statistics:
		var value = Global.statistics[key]
		
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 10)
		
		var key_label = Label.new()
		key_label.text = key + ":"
		key_label.add_theme_color_override("font_color", Color.WHITE)
		var value_label = Label.new()
		value_label.text = str(value)
		value_label.add_theme_color_override("font_color", Color.WHITE)
		hbox.add_child(key_label)
		hbox.add_child(value_label)
		
		stats_container.add_child(hbox)
		
		

func _generate_keybind_ui() -> void:
	for child in keybind_list.get_children():
		child.queue_free()
		
	for action in SettingsManager.REBINDABLE_ACTIONS:
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 10)
		
		var label = Label.new()
		label.text = action.capitalize().replace("_", " ") + ":"
		label.add_theme_color_override("font_color", Color.WHITE)
		label.custom_minimum_size = Vector2(150, 0)
		hbox.add_child(label)
		
		var btn_primary = Button.new()
		btn_primary.text = _get_key_name(action, 0)
		btn_primary.custom_minimum_size = Vector2(120, 0)
		btn_primary.pressed.connect(_on_rebind_button_pressed.bind(btn_primary, action, 0))
		hbox.add_child(btn_primary)
		
		var btn_secondary = Button.new()
		btn_secondary.text = _get_key_name(action, 1)
		btn_secondary.custom_minimum_size = Vector2(120, 0)
		btn_secondary.pressed.connect(_on_rebind_button_pressed.bind(btn_secondary, action, 1))
		hbox.add_child(btn_secondary)
		
		keybind_list.add_child(hbox)

func _get_key_name(action: String, slot: int) -> String:
	var events: Array = SettingsManager.settings.keybindings.get(action, [null, null])
	if slot < events.size() and events[slot] != null:
		return events[slot].as_text().trim_suffix(" (Physical)")
	return "---"

func _on_rebind_button_pressed(btn: Button, action: String, slot: int) -> void:
	action_to_rebind = action
	slot_to_rebind = slot
	rebind_button_reference = btn
	btn.text = "Taste drücken..."
	get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
	if action_to_rebind == "":
		return
		
	if event is InputEventKey or (event is InputEventMouseButton and event.pressed):
		if event is InputEventKey and event.keycode == KEY_ESCAPE:
			_cancel_rebinding()
			get_viewport().set_input_as_handled()
			return
			
		if event is InputEventKey and (event.keycode == KEY_DELETE or event.keycode == KEY_BACKSPACE):
			SettingsManager.settings.keybindings[action_to_rebind][slot_to_rebind] = null
			_finish_rebinding()
			get_viewport().set_input_as_handled()
			return

		if SettingsManager.is_key_bound(event, action_to_rebind, slot_to_rebind):
			rebind_button_reference.text = "Bereits belegt!"
			await get_tree().create_timer(1.0).timeout
			_cancel_rebinding()
			get_viewport().set_input_as_handled()
			return
			
		SettingsManager.settings.keybindings[action_to_rebind][slot_to_rebind] = event
		_finish_rebinding()
		get_viewport().set_input_as_handled()

func _finish_rebinding() -> void:
	SettingsManager.apply_settings()
	SettingsManager.save_settings()
	if rebind_button_reference != null:
		rebind_button_reference.text = _get_key_name(action_to_rebind, slot_to_rebind)
	action_to_rebind = ""
	rebind_button_reference = null

func _cancel_rebinding() -> void:
	if rebind_button_reference != null:
		rebind_button_reference.text = _get_key_name(action_to_rebind, slot_to_rebind)
	action_to_rebind = ""
	rebind_button_reference = null
