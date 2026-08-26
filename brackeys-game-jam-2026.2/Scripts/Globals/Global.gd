extends Node

@export var num_of_costumes: int = 40
var free_costumes: Array[int]
var enemy_costumes: Array[int]
var all_costumes: Array[int]

var all_levels: Array[String] = ["Castle1", "Castle2","Castle3", "Market1", "Market2", "Market3"]
var cleared_levels: Array[String] = []
var unlocked_levels: Array[String] = ["Castle1"]
const SAVE_PATH = "user://savegame.cfg"

var statistics: Dictionary = {
	"Royal Deaths": 0,
	"Innocent Deaths": 0,
	"Murderer Deaths": 0,
	"Minutes played" : 0
}
enum death_cause {
	end_game_messages_you_killed_king,
	end_game_messages_murderer_killed_king,
	end_game_messages_you_killed_npc
}
var end_game_messages_you_killed_king: Dictionary = {
		"1": "You had one job...",
		"2": "Wrong Target, Bodyguard!",
		"3": "OORS, Wrong Royal..."
}
var end_game_messages_murderer_killed_king: Dictionary = {
		"1": "The crown has fallen!",
		"2": "Protection Failure",
		"3": "The king is dead. Long live ... wait."
}
var end_game_messages_you_killed_npc: Dictionary = {
		"1": "MASSACRE!",
		"2": "Collateral Damage",
		"3": "Paranoia in the line of duty"
}
var last_death_cause: death_cause = death_cause.end_game_messages_you_killed_king

func _ready() -> void:
	reset_costumes()
	load_game()
	_start_playtime_timer()

func _start_playtime_timer() -> void:
	var timer = Timer.new()
	timer.wait_time = 60.0 
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_on_playtime_timer_timeout)
	add_child(timer)


func _on_playtime_timer_timeout() -> void:
	statistics["Minutes played"] += 1
	save_game()
	

func save_death_cause(cause: death_cause) -> void:
	last_death_cause = cause
	
	match cause:
		death_cause.end_game_messages_you_killed_king, death_cause.end_game_messages_murderer_killed_king:
			statistics["Royal Deaths"] += 1
		death_cause.end_game_messages_you_killed_npc:
			statistics["Innocent Deaths"] += 1

	save_game()

func get_random_death_message() -> String:
	match last_death_cause:
		death_cause.end_game_messages_you_killed_king:
			return end_game_messages_you_killed_king.values().pick_random()
		death_cause.end_game_messages_murderer_killed_king:
			return end_game_messages_murderer_killed_king.values().pick_random()
		death_cause.end_game_messages_you_killed_npc:
			return end_game_messages_you_killed_npc.values().pick_random()
	return ""

func reset_costumes():
	enemy_costumes.clear()
	free_costumes.clear()
	all_costumes.clear()
	for i in range(num_of_costumes):
		free_costumes.append(i+1)
		all_costumes.append(i + 1)

func reset():
	reset_costumes()
	cleared_levels.clear()
	unlocked_levels = ["Castle1"]
	save_game()
	
func save_game() -> void:
	var config = ConfigFile.new()
	config.set_value("Progression", "cleared_levels", cleared_levels)
	config.set_value("Progression", "unlocked_levels", unlocked_levels)
	config.set_value("Stats" , "statistics", statistics)
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
	statistics = config.get_value("Stats", "statistics", statistics)
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
		
