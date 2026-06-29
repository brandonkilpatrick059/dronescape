extends Node2D

var current_alpha : float = 0.0
var max_alpha : float = 0.0
var fading_out = false
var animated_sprite : AnimatedSprite2D 

var follow_particle : Node = null

func _ready() -> void:
	modulate = Color(1,1,1,0)
	max_alpha = randf_range(0.4,0.8)
	animated_sprite = $AnimatedSprite2D
	animated_sprite.play("default")
	var scale_factor = randf_range(0.8,1.5)
	scale = Vector2(scale_factor,scale_factor)

func attach_particle(particle : Node):
	follow_particle = particle

func _physics_process(delta: float) -> void:
	if(follow_particle != null):
		global_position = Vector2(follow_particle.global_position.x,global_position.y)
	var alpha_step = 0.02 
	if(!fading_out && current_alpha > max_alpha):
		fading_out = true
	elif(!fading_out):
		current_alpha = current_alpha + alpha_step
	elif(fading_out && current_alpha > 0.0):
		current_alpha = current_alpha - alpha_step
	elif(fading_out && current_alpha <= 0.0):
		queue_free()
	modulate = Color(1,1,1,current_alpha)
