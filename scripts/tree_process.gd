extends Node

var timer := Timer.new()

var growth_wait_secs = 0.05

func _ready() -> void:
	timer.one_shot = true
	add_child(timer)

func _physics_process(delta: float) -> void:
	get_parent().queue_free_on_failed_placement_criteria()
	if(timer.is_stopped()):
		get_parent().propogate_growth()
		timer.start(growth_wait_secs)
