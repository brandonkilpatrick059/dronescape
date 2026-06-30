extends Grid_Entity

var criteria_lock_timer := Timer.new()

func _ready() -> void:
	grid_entity_init()
	criteria_lock_timer.one_shot = true
	add_child(criteria_lock_timer)
	criteria_lock_timer.start(0.1)
	add_to_group("updatable")

#func _physics_process(delta: float) -> void:
	#if(criteria_lock_timer.is_stopped()):
		#queue_free_on_failed_placement_criteria()

func update():
	if(criteria_lock_timer.is_stopped()):
		queue_free_on_failed_placement_criteria()
