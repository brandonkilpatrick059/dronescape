class_name Criteria_Collider extends Node2D

@onready var above_collider : Area2D = $above
@onready var left_collider : Area2D = $left
@onready var below_collider : Area2D = $below
@onready var right_collider : Area2D = $right
@onready var center_collider : Area2D = $center

func force_collision_update():
	$above/CollisionShape2D.disabled = true
	$above/CollisionShape2D.disabled = false
	
	$left/CollisionShape2D.disabled = true
	$left/CollisionShape2D.disabled = false
	
	$right/CollisionShape2D.disabled = true
	$right/CollisionShape2D.disabled = false
	
	$below/CollisionShape2D.disabled = true
	$below/CollisionShape2D.disabled = false
	
	$center/CollisionShape2D.disabled = true
	$center/CollisionShape2D.disabled = false

func get_above_overlapping() -> Array[Node2D]:
	return above_collider.get_overlapping_bodies()

func get_left_overlapping() -> Array[Node2D]:
	return left_collider.get_overlapping_bodies()

func get_below_overlapping() -> Array[Node2D]:
	return below_collider.get_overlapping_bodies()
	
func get_right_overlapping() -> Array[Node2D]:
	return right_collider.get_overlapping_bodies()

func get_center_overlapping() -> Array[Node2D]:
	return center_collider.get_overlapping_bodies()
