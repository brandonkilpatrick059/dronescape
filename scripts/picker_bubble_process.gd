extends Node2D

func _physics_process(delta: float) -> void:
	get_parent().handle_animation()
	get_parent().handle_input()
