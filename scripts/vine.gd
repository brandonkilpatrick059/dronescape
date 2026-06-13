class_name Vine extends Grid_Entity

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func set_orientation(name : String):
	sprite.play(name)
