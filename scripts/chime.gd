class_name Chime extends Grid_Entity

@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var wind_activation_area : Area2D = $wind_area

@export var wind_animations : Array[AnimatedSprite2D]
@export var sensitivity : float = 1.0
@export var sensitivity_fraction : float = 2.0
@export var friction : float = 0.002
@export var wind_velocity_attenuation : float = 2
@export var attack : float = 0.5

var activation_level : float = 0.0 #is 0.0 to 1.0
static var zero_volume : float = -80
var max_volume : float = -6.0
var volume_set_point : float = 0.0

var wind_affect_x_velocity : float = 0.0

func _ready() -> void:
	grid_entity_init()
	add_to_group("chime")
	initialize_audio()
	initialize_wind_animation()

func initialize_audio():
	audio_player.volume_db = zero_volume
	audio_player.play()

func initialize_wind_animation():
	for a_sprite : AnimatedSprite2D in wind_animations:
		a_sprite.play("default")
		a_sprite.speed_scale = 0.0

func update_wind_animation():
	for a_sprite : AnimatedSprite2D in wind_animations:
		var new_scale : float = activation_level
		if(wind_affect_x_velocity < 0.0):
			new_scale = -activation_level
		a_sprite.speed_scale = new_scale

func update_activation_level():
	var winds = wind_activation_area.get_overlapping_bodies()
	var highest_energy : float = 0.0
	for wind : Wind_Particle in winds:
		if(wind.get_energy() > highest_energy):
			highest_energy = wind.get_energy()
			wind_affect_x_velocity = wind.get_velocity_x()
		var attenuation = wind_velocity_attenuation
		if(wind_affect_x_velocity < 0):
			attenuation = - wind_velocity_attenuation
		wind.attenuate_velocity_x(attenuation)
	var new_activation = sensitivity * highest_energy
	if(new_activation > activation_level):
		activation_level = new_activation 
	activation_level = activation_level - friction
	if(activation_level > 1.0):
		activation_level = 1.0
	elif(activation_level < 0.0):
		activation_level = 0.0

func update_audio():
	var full_volume = -zero_volume
	var volume_fraction = full_volume * activation_level
	var current_volume = volume_fraction + zero_volume
	if(current_volume > max_volume):
		current_volume = max_volume
	volume_set_point = current_volume
	update_volume()

func update_volume():
	if(audio_player.volume_db < volume_set_point):
		audio_player.volume_db = audio_player.volume_db + attack
	elif(audio_player.volume_db > volume_set_point):
		audio_player.volume_db = audio_player.volume_db - attack
#func debug_input():
	#if(Input.is_action_pressed("second_action")):
		#if(activation_level < 1.0):
			#activation_level = activation_level + sensitivity
#
	#activation_level = activation_level - friction
	#if(activation_level > 1.0):
		#activation_level = 1.0
	#elif(activation_level < 0.0):
		#activation_level = 0.0

func _physics_process(delta: float) -> void:
	update_activation_level()
	update_wind_animation()
	update_audio()
	#debug_input()
	
