extends Node2D

@export var wait_time_secs : float = 1.0
@export var sets_cursor_active : bool = false
var current_alpha : float = 1.0
var timer := Timer.new()
var set_cursor = false

var fading_out = true
var fading_in = false

func _ready() -> void:
	visible = true
	timer.one_shot = true
	add_child(timer)
	timer.start(wait_time_secs)

func fade_in():
	if(!fading_out && !fading_in):
		fading_in = true

func fade_out():
	if(!fading_out && !fading_in):
		fading_out = true

func is_faded_out() -> bool:
	return current_alpha == 0.0

func is_faded_in() -> bool:
	return current_alpha == 1.0

func _physics_process(delta: float) -> void:
	if(timer.is_stopped()):
		if(current_alpha > 0.0 && fading_out):
			current_alpha = current_alpha - 0.005
		elif(current_alpha <= 0.0 && fading_out):
			fading_out = false
			current_alpha = 0.0
		elif(current_alpha < 1.0 && fading_in):
			current_alpha = current_alpha + 0.005
		elif(current_alpha >= 1.0 && fading_in):
			fading_in = false
			current_alpha = 1.0
		modulate = Color(1,1,1,current_alpha)
		if(!set_cursor && sets_cursor_active):
			var cursor = get_tree().get_first_node_in_group("cursor")
			cursor.set_active()
			set_cursor = true
