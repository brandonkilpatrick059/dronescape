extends Node

var criteria_lockout_timer := Timer.new()
var timer := Timer.new()

var growth_wait_secs = 0.05

func _ready() -> void:
	timer.one_shot = true
	add_child(timer)
	criteria_lockout_timer.one_shot = true
	add_child(criteria_lockout_timer)
	criteria_lockout_timer.start(0.1)

func _physics_process(delta: float) -> void:
	if(criteria_lockout_timer.is_stopped()):
		get_parent().queue_free_on_failed_placement_criteria()
	if(timer.is_stopped()):
		get_parent().propogate_growth()
		timer.start(growth_wait_secs)
