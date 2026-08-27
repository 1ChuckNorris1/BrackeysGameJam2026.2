extends Button

signal long_released

var mouse_inside := false
var duration_pressed: float = 0.0
var released := false

@onready var progress_bar: ProgressBar = $ProgressBar
@export var duration_treshhold: float = 1.1

func _ready() -> void:
	progress_bar.value = 0.0
	if not mouse_entered.is_connected(grab_focus):
		mouse_entered.connect(grab_focus)
	if not focus_entered.is_connected(_on_choice_button_focus_entered.bind(self)):
		focus_entered.connect(_on_choice_button_focus_entered.bind(self))
		
	mouse_entered.connect(mouse_status.bind(true))
	mouse_exited.connect(mouse_status.bind(false))
	
	focus_entered.connect(mouse_status.bind(true))
	focus_exited.connect(mouse_status.bind(false)) 
	
	progress_bar.max_value = duration_treshhold
	
func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse_inside and not released:
		duration_pressed += delta
		progress_bar.value = duration_pressed
		
		# Event feuern, sobald das Limit erreicht wurde
		if duration_pressed >= duration_treshhold:
			released = true
			long_released.emit()
			
			#Debug
			
			#Global.unlock_all_levels()
			
			
	elif not released:
		if duration_pressed > 0.0:
			duration_pressed = 0.0
			var tween = create_tween()
			tween.tween_property(progress_bar, "value", 0.0, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)

func mouse_status(is_inside: bool) -> void:
	mouse_inside = is_inside
	if not is_inside:
		_reset_button()

func _on_choice_button_focus_entered(button: Button) -> void:
	pass

func _reset_button() -> void:
	duration_pressed = 0.0
	released = false
	progress_bar.value = 0.0
