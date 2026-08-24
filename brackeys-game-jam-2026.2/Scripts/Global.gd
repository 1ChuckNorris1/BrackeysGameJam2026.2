extends Node

@export var num_of_costumes: int = 26
var free_costumes: Array[int]


func _ready() -> void:
	for i in range(num_of_costumes):
		free_costumes.append(i+1)
