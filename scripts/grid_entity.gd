@tool
class_name Grid_Entity extends Node2D

func _ready() -> void:
	grid_entity_init()

func grid_entity_init():
	add_to_group("grid_entity")

func cursor_destroy():
	queue_free()
