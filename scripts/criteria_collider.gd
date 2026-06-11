class_name Criteria_Collider extends Node2D

@onready var above_collider : Area2D = $above
@onready var left_collider : Area2D = $left
@onready var below_collider : Area2D = $below
@onready var right_collider : Area2D = $right

func get_above_overlapping() -> Array[Node2D]:
	return above_collider.get_overlapping_bodies()

func get_left_overlapping() -> Array[Node2D]:
	return left_collider.get_overlapping_bodies()

func get_below_overlapping() -> Array[Node2D]:
	return below_collider.get_overlapping_bodies()
	
func get_right_overlapping() -> Array[Node2D]:
	return right_collider.get_overlapping_bodies()
