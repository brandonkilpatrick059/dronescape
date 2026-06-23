class_name Wind_Attenuator extends Grid_Entity

@onready var wind_activation_area : Area2D = $wind_area

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@export var sensitivity : float = 1.0
@export var sensitivity_fraction : float = 2.0
@export var friction : float = 0.002


var activation_level : float = 0.0 #is 0.0 to 1.0

var wind_affect_x_velocity : float = 0.0

var speed_set_scale : float = 0.0

var criteria_lock_timer := Timer.new()

func _ready() -> void:
	grid_entity_init()
	add_to_group("machine")
	
	#locks criteria checks to prevent
	#queue_freeing during loading
	criteria_lock_timer.one_shot = true
	add_child(criteria_lock_timer)
	criteria_lock_timer.start(0.1)
	sprite.play("default")

func update_wind_animation():
	var new_scale : float = activation_level
	if(wind_affect_x_velocity < 0.0):
		new_scale = -activation_level
	speed_set_scale = new_scale
	if(sprite.speed_scale < speed_set_scale):
		sprite.speed_scale = sprite.speed_scale + 0.1
	elif(sprite.speed_scale > speed_set_scale):
		sprite.speed_scale = sprite.speed_scale - 0.1

func update_activation_level():
	var winds = wind_activation_area.get_overlapping_bodies()
	var highest_energy : float = 0.0
	var new_wind_affect_x_velocity = 0.0
	for wind : Wind_Particle in winds:
		if(wind.get_energy() > highest_energy):
			highest_energy = wind.get_energy()
			new_wind_affect_x_velocity = wind.get_velocity_x()
		var wind_velocity_attenuation : float = 3.30
		var attenuation = wind_velocity_attenuation
		if(wind_affect_x_velocity < 0):
			attenuation = - wind_velocity_attenuation
		wind.attenuate_velocity_x(attenuation)
	var new_activation = sensitivity * highest_energy
	if(new_activation > activation_level):
		activation_level = new_activation 
		wind_affect_x_velocity = new_wind_affect_x_velocity
	activation_level = activation_level - friction
	if(activation_level > 1.0):
		activation_level = 1.0
	elif(activation_level < 0.0):
		activation_level = 0.0

func _physics_process(delta: float) -> void:
	update_activation_level()
	update_wind_animation()
	if(criteria_lock_timer.is_stopped()):
		queue_free_on_failed_placement_criteria()
