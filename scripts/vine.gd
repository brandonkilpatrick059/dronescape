class_name Vine extends Grid_Entity

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var vine_flower : PackedScene = preload("res://entities/plants/vine_flower.tscn")
var timer := Timer.new()

var min_growth_time : float = 1.0
var max_growth_time : float = 10.0

var vine_flower_ref = null
var grass_created = false

var spawns_flowers = false

var criteria_lock_timer := Timer.new()

func _ready() -> void:
	grid_entity_init()
	criteria_lock_timer.one_shot = true
	add_child(criteria_lock_timer)
	timer.one_shot = true
	add_child(timer)
	timer.start(randf_range(min_growth_time,max_growth_time))
	spawns_flowers = randf_range(0.0,1.0) < 0.20
	criteria_lock_timer.start(0.1)

func set_orientation(name : String):
	sprite.play(name)

func _physics_process(delta: float) -> void:
	if(criteria_lock_timer.is_stopped()):
		queue_free_on_failed_placement_criteria()
	if(spawns_flowers && timer.is_stopped() && vine_flower_ref == null):
		if(grass_created):
			grass_created = false
			timer.start(randf_range(min_growth_time,max_growth_time))
		else:
			vine_flower_ref = vine_flower.instantiate()
			get_parent().add_child(vine_flower_ref)
			vine_flower_ref.global_position = global_position
			grass_created = true
