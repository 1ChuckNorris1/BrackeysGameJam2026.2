extends Node

const SAVE_PATH = "user://settings.cfg"
var config = ConfigFile.new()

const REBINDABLE_ACTIONS = ["move_up", "move_right", "move_down", "move_left", "attack"]

var settings = {
	"fullscreen": false,
	"resolution": Vector2i(1920, 1080),
	"master_volume": 1.0,
	"music_volume": 1.0,
	"sfx_volume": 1.0,
	"keybindings": {}
}

func _ready() -> void:
	_fetch_default_keybindings()
	load_settings()

func _fetch_default_keybindings() -> void:
	for action in REBINDABLE_ACTIONS:
		var events = InputMap.action_get_events(action)
		var key_events: Array[InputEvent] = []
		
		for event in events:
			if event is InputEventKey or event is InputEventMouseButton:
				key_events.append(event)
				if key_events.size() == 2:
					break
		
		while key_events.size() < 2:
			key_events.append(null)
			
		settings.keybindings[action] = key_events

func apply_settings() -> void:
	if settings.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(settings.resolution)
		var screen_center = DisplayServer.screen_get_position() + (DisplayServer.screen_get_size() / 2)
		var window_position = screen_center - (settings.resolution / 2)
		DisplayServer.window_set_position(window_position)

	_update_bus_volume("Master", settings.master_volume)
	_update_bus_volume("Music", settings.music_volume)
	_update_bus_volume("SFX", settings.sfx_volume)

	for action in settings.keybindings.keys():
		var events: Array = settings.keybindings[action]
		
		var existing_events = InputMap.action_get_events(action)
		for old_event in existing_events:
			if old_event is InputEventKey or old_event is InputEventMouseButton:
				InputMap.action_erase_event(action, old_event)
		
		for event in events:
			if event != null:
				InputMap.action_add_event(action, event)

func is_key_bound(new_event: InputEvent, ignore_action: String = "", ignore_slot: int = -1) -> bool:
	if new_event == null:
		return false
		
	for action in settings.keybindings.keys():
		var events: Array = settings.keybindings[action]
		for slot in range(events.size()):
			if action == ignore_action and slot == ignore_slot:
				continue
			var event = events[slot]
			if event != null and _is_same_event(event, new_event):
				return true
	return false

func _is_same_event(e1: InputEvent, e2: InputEvent) -> bool:
	if e1 is InputEventKey and e2 is InputEventKey:
		var k1 = e1.physical_keycode if e1.physical_keycode != KEY_NONE else e1.keycode
		var k2 = e2.physical_keycode if e2.physical_keycode != KEY_NONE else e2.keycode
		return k1 == k2
	if e1 is InputEventMouseButton and e2 is InputEventMouseButton:
		return e1.button_index == e2.button_index
	return false

func save_settings() -> void:
	config.set_value("video", "fullscreen", settings.fullscreen)
	config.set_value("video", "resolution", settings.resolution)
	
	config.set_value("audio", "master_volume", settings.master_volume)
	config.set_value("audio", "music_volume", settings.music_volume)
	config.set_value("audio", "sfx_volume", settings.sfx_volume)
	
	for action in settings.keybindings.keys():
		config.set_value("controls", action, settings.keybindings[action])
	
	var err = config.save(SAVE_PATH)
	if err != OK:
		push_error("Fehler beim Speichern: %d" % err)

func load_settings() -> void:
	var err = config.load(SAVE_PATH)
	if err != OK:
		apply_settings()
		save_settings()
		return
	
	settings.fullscreen = config.get_value("video", "fullscreen", false)
	settings.resolution = config.get_value("video", "resolution", Vector2i(1920, 1080))
	
	settings.master_volume = config.get_value("audio", "master_volume", 1.0)
	settings.music_volume = config.get_value("audio", "music_volume", 1.0)
	settings.sfx_volume = config.get_value("audio", "sfx_volume", 1.0)
	
	for action in REBINDABLE_ACTIONS:
		if config.has_section_key("controls", action):
			var loaded_events = config.get_value("controls", action)
			if loaded_events is Array and loaded_events.size() == 2:
				settings.keybindings[action] = loaded_events
	
	apply_settings()

func _update_bus_volume(bus_name: String, linear_value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_value))
		AudioServer.set_bus_mute(bus_index, linear_value <= 0.0001)
