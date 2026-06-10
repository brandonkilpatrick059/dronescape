extends Node2D

var current_alpha : float = 0.0
var max_alpha : float = 0.0
var fading_out = false
var animated_sprite : AnimatedSprite2D 

func _ready() -> void:
	modulate = Color(1,1,1,0)
	max_alpha = randf_range(0.4,0.8)
	animated_sprite = $AnimatedSprite2D
	animated_sprite.play("default")

func _physics_process(delta: float) -> void:
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
