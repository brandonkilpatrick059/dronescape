class_name Mist extends Node2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

#var timer := Timer.new()

var x_speed : float = 0.0
var y_speed : float = 0.0

func _ready() -> void:
	#timer.one_shot = true
	#add_child(timer)
	#timer.start(randf_range(0.2,0.35))
	sprite.speed_scale = randf_range(0.5,1.0)
	x_speed = randf_range(-0.2,0.2)
	y_speed = randf_range(0.0,-0.2)
	rotation_degrees = 90.0 * randi_range(0,2)
	sprite.play("default")

func _physics_process(delta: float) -> void:
	global_position = global_position + (Vector2(x_speed,y_speed))
	if(sprite.frame == sprite.sprite_frames.get_frame_count("default")-1):
		queue_free()
	
