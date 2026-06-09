class_name Wind_Particle extends RigidBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

static var top_force = 20000
static var top_speed = 200
var launched = false

var life_timer := Timer.new()

func launch(force_vect : Vector2):
	apply_force(force_vect)
	launched = true
	life_timer.one_shot
	add_child(life_timer)
	life_timer.start(10.0)

func get_energy() -> float:
	var speed = linear_velocity.length()
	return speed/top_speed
	
func _physics_process(delta: float) -> void:
	var num_frames : float = float(animated_sprite.sprite_frames.get_frame_count("default"))
	var current_frame : int = int(get_energy() * num_frames)
	animated_sprite.frame = current_frame
	var camera = get_tree().get_first_node_in_group("camera")
	if(global_position.distance_to(camera.global_position) > 800):
		queue_free()
	if(life_timer.is_stopped()):
		queue_free()
	if(launched && get_energy() < 0.1):
		queue_free()
