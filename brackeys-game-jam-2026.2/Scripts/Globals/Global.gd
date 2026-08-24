extends Node

@export var num_of_costumes: int = 40
var free_costumes: Array[int]
var enemy_costumes: Array[int]

var all_levels: Array[String] = ["Castle1", "Castle2", "Market1", "Market2"]
var cleared_levels: Array[String] = []
var unlocked_levels: Array[String] = ["Castle1"]
const SAVE_PATH = "user://savegame.cfg"

func _ready() -> void:
	reset_costumes()
	load_game()

func reset_costumes():
	enemy_costumes.clear()
	for i in range(num_of_costumes):
		free_costumes.append(i+1)

func reset():
	reset_costumes()
	cleared_levels.clear()
	unlocked_levels = ["Castle1"]
	save_game()
	
func save_game() -> void:
	var config = ConfigFile.new()
	config.set_value("Progression", "cleared_levels", cleared_levels)
	config.set_value("Progression", "unlocked_levels", unlocked_levels)
	var error = config.save(SAVE_PATH)
	if error != OK:
		print("Fehler beim Speichern des Spielstands: ", error)

func load_game() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	if error != OK:
		print("Kein Spielstand gefunden, starte neues Spiel.")
		return
	cleared_levels = config.get_value("Progression", "cleared_levels", [])
	unlocked_levels = config.get_value("Progression", "unlocked_levels", ["Level1"])
	print("Spielstand erfolgreich geladen!")

func win_level(level:String):
	if not cleared_levels.has(level):
		cleared_levels.append(level)
	var next_level_index = all_levels.find(level) + 1
	if next_level_index < all_levels.size():
		var next_level_name = all_levels[next_level_index]
		if not unlocked_levels.has(next_level_name):
			unlocked_levels.append(next_level_name)
	save_game()
		

	
	
		
		
