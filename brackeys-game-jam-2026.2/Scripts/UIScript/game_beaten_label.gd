extends Label

func _ready() -> void:
	var royal_deaths = str(Global.statistics.get("Royal Deaths", 0))
	text = "After " + royal_deaths + " Royal Deaths you actually made it!"
