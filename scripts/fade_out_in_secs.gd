extends Node2D

@export var wait_time_secs : float = 1.0
@export var sets_cursor_active : bool = false
var current_alpha : float = 1.0
var timer := Timer.new()
var set_cursor = false

func _ready() -> void:
	visible = true
	timer.one_shot = true
	add_child(timer)
	timer.start(wait_time_secs)

func _physics_process(delta: float) -> void:
	if(timer.is_stopped()):
		if(current_alpha > 0.0):
			current_alpha = current_alpha - 0.005
		modulate = Color(1,1,1,current_alpha)
		if(!set_cursor && sets_cursor_active):
			var cursor = get_tree().get_first_node_in_group("cursor")
			cursor.set_active()
			set_cursor = true
		
