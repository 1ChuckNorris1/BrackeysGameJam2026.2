extends Node

@export var num_of_costumes: int = 26
var free_costumes: Array[int]
var enemy_costumes: Array[int]

var all_levels: Array[String] = ["Castle 1", "Castle2", "Market1", "Market2"]
var cleared_levels: Array[String] = []
var unlocked_levels: Array[String] = ["Castle1"]


func _ready() -> void:
	enemy_costumes.clear()
	for i in range(num_of_costumes):
		free_costumes.append(i+1)

func reset():
	_ready()
	
