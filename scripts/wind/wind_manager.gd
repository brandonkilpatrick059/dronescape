class_name Wind_Manager extends Node2D

var timer := Timer.new()

var wind_particle = preload("res://wind/wind_particle.tscn")

var min_wind_speed = 6000
var max_wind_speed = 20000
var current_wind_speeds = min_wind_speed
var wind_speeds_rising = true

var change_weight = 0.0

static var wind_visible = false

var zero_volume = -60
var max_volume = -12
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

var height = 640
var width = 0
var set_width = 640
var switch_lock = false

static func get_wind_visible() -> bool:
	return wind_visible

static func set_wind_visible(set_to : bool):
	wind_visible = set_to

func _ready() -> void:
	timer.one_shot = true
	add_child(timer)
	audio_player.volume_db = zero_volume
	audio_player.play()
	if(randf_range(0.0,1.0) < 0.5):
		width = set_width

func generate_wind():
	var point_step = 16
	var current_step = 0
	if(wind_speeds_rising && current_wind_speeds < max_wind_speed):
		current_wind_speeds = current_wind_speeds + randf_range(250,500)
	elif(!wind_speeds_rising && current_wind_speeds > min_wind_speed):
		current_wind_speeds = current_wind_speeds - randf_range(250,500)
	if(!switch_lock && current_wind_speeds - min_wind_speed < 50):
		switch_lock = true
		if(width == 0):
			width = 640
		else:
			width = 0
	elif(current_wind_speeds - min_wind_speed > 50):
		switch_lock = false
	if(randf_range(0.0,1.0) - change_weight < 0.01):
		wind_speeds_rising = !wind_speeds_rising
		change_weight = 0.0
	else: 
		change_weight = change_weight + 0.002
	while(current_step < height):
		current_step = current_step + point_step
		var particle = wind_particle.instantiate()
		add_child(particle)
		particle.global_position = global_position + (Vector2(width,global_position.y + current_step))
		var wind_launch_force = current_wind_speeds
		if(width != 0):
			wind_launch_force = -current_wind_speeds
		particle.launch(Vector2(wind_launch_force,0))
	
func handle_input():
	if(Input.is_action_just_pressed("dev_1")):
		wind_visible = !wind_visible

func update_audio():
	var wind_level = current_wind_speeds/max_wind_speed
	var full_volume = -zero_volume
	var volume_fraction = full_volume * wind_level
	var current_volume = volume_fraction + zero_volume + max_volume
	audio_player.volume_db = current_volume

func update_wind_particles():
	var wind_particles = get_tree().get_nodes_in_group("wind_particle")
	for wind : Wind_Particle in wind_particles:
		var num_frames : float = float(wind.get_animated_sprite().sprite_frames.get_frame_count("default"))
		var current_frame : int = int(wind.get_energy() * num_frames)
		wind.get_animated_sprite().frame = current_frame
		wind.visible = Wind_Manager.get_wind_visible()
		var camera = get_tree().get_first_node_in_group("camera") 
		var wind_streak = load("res://effects/wind_streak.tscn")
		if(wind.get_energy() > 0.4   &&
		!wind.get_wind_streak_created() && 
		randf_range(0.0,1.0) < 0.0002): 
			wind.set_wind_streak_ref(wind_streak.instantiate())
			wind.get_parent().add_child(wind.wind_streak_ref)
			wind.get_wind_streak_ref().global_position = global_position
			wind.set_wind_streak_created()
		if(wind.get_wind_streak_created() && wind.get_wind_streak_ref() != null):
			wind.get_wind_streak_ref().global_position = Vector2(wind.global_position.x,wind.get_wind_streak_ref().global_position.y)
		if(wind.global_position.distance_to(camera.global_position) > 800):
			wind.queue_free()
		if(wind.life_timer.is_stopped()):
			wind.queue_free()
		if(wind.launched && wind.get_energy() < 0.1):
			wind.queue_free()

func _physics_process(delta: float) -> void:
	handle_input()
	#update_wind_particles()
	if(timer.is_stopped()):
		generate_wind()
		update_audio()
		timer.start(0.5)
