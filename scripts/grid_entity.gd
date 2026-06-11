@tool
class_name Grid_Entity extends Node2D

@export var placement_criteria : Place_Criteria = null

var criteria_collider : Criteria_Collider = null

func _ready() -> void:
	grid_entity_init()

func grid_entity_init():
	add_to_group("grid_entity")
	if(placement_criteria != null):
		init_collider()

func cursor_destroy():
	queue_free()

func init_collider():
	var collider = load("res://entities/criteria_collider.tscn")
	var new_collider = collider.instantiate()
	criteria_collider = new_collider
	add_child(criteria_collider)

func get_placement_criteria() -> Place_Criteria:
	return placement_criteria

func set_placement_criteria(criteria : Place_Criteria):
	placement_criteria = criteria
	init_collider()

func queue_free_on_failed_placement_criteria():
	if(!check_criteria()):
		queue_free()

func check_criteria() -> bool:
	if(placement_criteria == null):
		return true
	else:
		var above : Array[Node2D] =  []
		above.append_array(criteria_collider.get_above_overlapping())
		var left : Array[Node2D] =  []
		left.append_array(criteria_collider.get_left_overlapping())
		var below : Array[Node2D] =  []
		below.append_array(criteria_collider.get_below_overlapping())
		var right : Array[Node2D] =  []
		right.append_array(criteria_collider.get_right_overlapping())
		return placement_criteria.check_criteria(above,left,below,right)
