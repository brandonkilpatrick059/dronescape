class_name Tall_Grass extends Grid_Entity

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var wind_activation_area : Area2D = $Area2D

var growth_level = 1 

var timer := Timer.new()

var min_growth_time : float = 10.0
var max_growth_time : float = 60.0

var activation_level : float = 0.0 #is 0.0 to 1.0
var wind_affect_x_velocity : float = 0.0
var speed_set_scale : float = 0.0
var sensitivity = 0.8
var friction = 0.2

var animate_direction : String = ""

var still = true

func _ready() -> void:
	grid_entity_init()
	timer.one_shot = true
	add_child(timer)
	timer.start(randf_range(min_growth_time,max_growth_time))
	add_to_group("updatable")

func update_wind_animation():
	var wind_effect_activation_level = 0.1 
	if(activation_level > wind_effect_activation_level):
		var new_animate_direction = ""
		if(wind_affect_x_velocity > 0.0):
			new_animate_direction = "_right"
		else:
			new_animate_direction = "_left"
		if(new_animate_direction != animate_direction || still):
			animate_direction = new_animate_direction
			var animation = str(growth_level,animate_direction)
			sprite.play(animation)
			still = false
	speed_set_scale = activation_level
	if(sprite.speed_scale < speed_set_scale):
		sprite.speed_scale = sprite.speed_scale + 0.01
	elif(sprite.speed_scale > speed_set_scale):
		sprite.speed_scale = sprite.speed_scale - 0.01

func update_activation_level():
	var winds = wind_activation_area.get_overlapping_bodies()
	var highest_energy : float = 0.0
	var new_wind_affect_x_velocity = 0.0
	for wind : Wind_Particle in winds:
		if(wind.get_energy() > highest_energy):
			highest_energy = wind.get_energy()
			new_wind_affect_x_velocity = wind.get_velocity_x()
	var new_activation = sensitivity * highest_energy
	if(new_activation > activation_level):
		activation_level = new_activation 
		wind_affect_x_velocity = new_wind_affect_x_velocity
	activation_level = activation_level - friction
	if(activation_level > 1.0):
		activation_level = 1.0
	elif(activation_level < 0.0):
		activation_level = 0.0

#func _physics_process(delta: float) -> void:
	#queue_free_on_failed_placement_criteria()
	#update_activation_level()
	#update_wind_animation()
	#if(timer.is_stopped() && growth_level == 1):
		#growth_level = 2

func update():
	queue_free_on_failed_placement_criteria()
	update_activation_level()
	update_wind_animation()
	if(timer.is_stopped() && growth_level == 1):
		growth_level = 2
