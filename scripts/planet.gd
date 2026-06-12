extends Sprite2D

var origin_point : Vector2

func _ready() -> void:
	origin_point = position

func _physics_process(delta: float) -> void:
	var speed : float = 0.006

	position = position + Vector2(speed*2,-speed)
	if(position.distance_to(origin_point) > 1545):
		position = origin_point
