extends Node

var timer := Timer.new()

func _ready() -> void:
	timer.one_shot = true
	add_child(timer)
	timer.start(0.05)

func _physics_process(delta: float) -> void:
	if(timer.is_stopped()):
		get_parent().propogate_growth()
		queue_free()
