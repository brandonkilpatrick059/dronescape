class_name Wind_Particle extends RigidBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var wind_streak = preload("res://effects/wind_streak.tscn")

static var top_force = 20000
static var top_speed = 200
var launched = false

var life_timer := Timer.new()

var wind_streak_created = false
var wind_streak_ref = null

func launch(force_vect : Vector2):
	apply_force(force_vect)
	launched = true
	life_timer.one_shot
	add_child(life_timer)
	life_timer.start(10.0)

func get_energy() -> float:
	var speed = linear_velocity.length()
	return speed/top_speed

func get_velocity_x() -> float:
	return linear_velocity.x

func attenuate_velocity_x(amount : float):
	linear_velocity.x = linear_velocity.x - amount

func _physics_process(delta: float) -> void: 
	var num_frames : float = float(animated_sprite.sprite_frames.get_frame_count("default"))
	var current_frame : int = int(get_energy() * num_frames)
	animated_sprite.frame = current_frame
	visible = Wind_Manager.get_wind_visible()
	var camera = get_tree().get_first_node_in_group("camera") 
	if(get_energy() > 0.4   &&
	!wind_streak_created && 
	randf_range(0.0,1.0) < 0.0002): 
		wind_streak_ref = wind_streak.instantiate()
		#var rotate = Vector2(1.0,0.0).angle_to(linear_velocity)
		#wind_streak_ref.rotation = rotate
		get_parent().add_child(wind_streak_ref)
		wind_streak_ref.global_position = global_position
		wind_streak_created = true
	if(wind_streak_created && wind_streak_ref != null):
		wind_streak_ref.global_position = Vector2(global_position.x,wind_streak_ref.global_position.y)
		#var rotate = Vector2(1.0,0.0).angle_to(linear_velocity)
		#wind_streak_ref.rotation = rotate
	if(global_position.distance_to(camera.global_position) > 800):
		queue_free()
	if(life_timer.is_stopped()):
		queue_free()
	if(launched && get_energy() < 0.1):
		queue_free()
