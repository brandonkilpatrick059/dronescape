class_name Grass extends Grid_Entity

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var tall_grass : PackedScene = preload("res://entities/plants/tall_grass.tscn")
var timer := Timer.new()
var criteria_lock_timer := Timer.new()

var min_growth_time : float = 10.0
var max_growth_time : float = 60.0

var tall_grass_ref = null
var grass_created = false

func _ready() -> void:
	grid_entity_init()
	criteria_lock_timer.one_shot = true
	add_child(criteria_lock_timer)
	timer.one_shot = true
	add_child(timer)
	timer.start(randf_range(min_growth_time,max_growth_time))
	criteria_lock_timer.start(0.1)
	add_to_group("orientable")
	add_to_group("updatable")

func get_orient_group() -> String:
	return "grass"

func set_orientation(name : String):
	sprite.play(name)

#func _physics_process(delta: float) -> void:
	#if(criteria_lock_timer.is_stopped()):
		#queue_free_on_failed_placement_criteria()
	#if(timer.is_stopped() && tall_grass_ref == null):
		#if(grass_created):
			#grass_created = false
			#timer.start(randf_range(min_growth_time,max_growth_time))
		#else:
			#tall_grass_ref = tall_grass.instantiate()
			#get_parent().add_child(tall_grass_ref)
			#tall_grass_ref.global_position = global_position + Vector2(0,-16)
			#grass_created = true

func update():
	if(criteria_lock_timer.is_stopped()):
		queue_free_on_failed_placement_criteria()
	if(timer.is_stopped() && tall_grass_ref == null):
		if(grass_created):
			grass_created = false
			timer.start(randf_range(min_growth_time,max_growth_time))
		else:
			tall_grass_ref = tall_grass.instantiate()
			get_parent().add_child(tall_grass_ref)
			tall_grass_ref.global_position = global_position + Vector2(0,-16)
			grass_created = true
