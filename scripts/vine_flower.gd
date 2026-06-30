class_name Vine_Flower extends Grid_Entity

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var wind_activation_area : Area2D = $Area2D

var growth_level = 1 

var timer := Timer.new()

var min_growth_time : float = 1.0
var max_growth_time : float = 5.0

var animate_direction : String = ""

var still = true

func _ready() -> void:
	grid_entity_init()
	timer.one_shot = true
	add_child(timer)
	timer.start(randf_range(min_growth_time,max_growth_time))
	if(randf_range(0.0,1.0) < 0.5):
		scale = Vector2(-scale.x,scale.y)
	if(randf_range(0.0,1.0) < 0.5):
		scale = Vector2(scale.x,-scale.y)
	add_to_group("updatable")

#func _physics_process(delta: float) -> void:
	#queue_free_on_failed_placement_criteria()
	#if(timer.is_stopped() && growth_level < 4):
		#growth_level = growth_level + 1
		#timer.start(randf_range(min_growth_time,max_growth_time))
		#sprite.play(str(growth_level))

func update():
	queue_free_on_failed_placement_criteria()
	if(timer.is_stopped() && growth_level < 4):
		growth_level = growth_level + 1
		timer.start(randf_range(min_growth_time,max_growth_time))
		sprite.play(str(growth_level))
