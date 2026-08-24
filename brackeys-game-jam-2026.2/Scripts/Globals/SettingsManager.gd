extends Node

const SAVE_PATH = "user://settings.cfg"
var config = ConfigFile.new()

var settings = {
	"fullscreen": false,
	"resolution": Vector2i(1920, 1080)
}

func _ready():
	load_settings()

func apply_settings():
	# Fenster-Modus setzen
	if settings.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(settings.resolution)
		var screen_center = DisplayServer.screen_get_position() + (DisplayServer.screen_get_size() / 2)
		var window_position = screen_center - (settings.resolution / 2)
		DisplayServer.window_set_position(window_position)

func save_settings():
	config.set_value("video", "fullscreen", settings.fullscreen)
	config.set_value("video", "resolution", settings.resolution)
	config.save(SAVE_PATH)

func load_settings():
	var err = config.load(SAVE_PATH)
	if err != OK:
		# Falls keine Datei existiert, Standardwerte anwenden
		apply_settings()
		return

	settings.fullscreen = config.get_value("video", "fullscreen", false)
	settings.resolution = config.get_value("video", "resolution", Vector2i(1920, 1080))
	apply_settings()
