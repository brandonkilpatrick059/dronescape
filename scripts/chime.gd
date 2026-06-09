class_name Chime extends Grid_Entity

@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var wind_activation_area : Area2D = $wind_area

@export var wind_animations : Array[AnimatedSprite2D]
@export var sensitivity : float = 1.0
@export var sensitivity_fraction : float = 2.0
@export var friction : float = 0.002

var activation_level : float = 0.0 #is 0.0 to 1.0
static var zero_volume = -50

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
		a_sprite.speed_scale = activation_level

func update_activation_level():
	var winds = wind_activation_area.get_overlapping_bodies()
	for wind in winds:
		activation_level = activation_level/sensitivity_fraction + (sensitivity * wind.get_energy())
	activation_level = activation_level - friction
	if(activation_level > 1.0):
		activation_level = 1.0
	elif(activation_level < 0.0):
		activation_level = 0.0

func update_audio():
	var full_volume = -zero_volume
	var volume_fraction = full_volume * activation_level
	var current_volume = volume_fraction + zero_volume
	audio_player.volume_db = current_volume

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
	
