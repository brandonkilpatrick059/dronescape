@tool
class_name Grid_Entity extends Node2D

@export var placement_criteria : Place_Criteria = null
@export var packedscene_path : String = ""

var criteria_collider : Criteria_Collider = null

var is_loaded : bool = false

func _ready() -> void:
	grid_entity_init()

func grid_entity_init():
	add_to_group("grid_entity")
	if(placement_criteria != null):
		init_collider()

func set_is_loaded():
	is_loaded = true

func get_is_loaded():
	return is_loaded

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

func get_packedscene_path() -> String:
	return packedscene_path

#called on entities in group "orientable"
func orient_self():
	var entity_above : bool = false
	var entity_below : bool = false
	var entity_right : bool = false
	var entity_left : bool = false
	criteria_collider.force_collision_update()
	var above_overlapping = criteria_collider.get_above_overlapping()
	var below_overlapping = criteria_collider.get_below_overlapping()
	var right_overlapping = criteria_collider.get_right_overlapping()
	var left_overlapping = criteria_collider.get_left_overlapping()
	entity_above = has_orient_group(above_overlapping)
	entity_below = has_orient_group(below_overlapping)
	entity_right = has_orient_group(right_overlapping)
	entity_left = has_orient_group(left_overlapping)
	var animation_name = "center_center"
	if(entity_right && entity_above && !entity_left && entity_below):
		animation_name = "center_left"
	elif(!entity_right && entity_above && entity_left && entity_below):
		animation_name = "center_right"
	elif(!entity_right && entity_left && !entity_below):
		animation_name = "bottom_right"
	elif(entity_right && !entity_left && !entity_below):
		animation_name = "bottom_left"
	elif(entity_right && !entity_above && !entity_left && entity_below):
		animation_name = "top_left"
	elif(!entity_right && !entity_above && entity_left && entity_below):
		animation_name = "top_right"
	elif(entity_above && !entity_below):
		animation_name = "bottom_center"
	elif(!entity_above && entity_below):
		animation_name = "top_center"
	set_orientation(animation_name)

func has_orient_group(entities : Array[Node2D]) -> bool:
	for entity in entities:
		var orient_group : String = get_orient_group()
		if entity.get_parent().is_in_group(orient_group):
			return true
	return false

func get_orient_group() -> String:
	return ""

#overridden in "orientable" objects
func set_orientation(name : String):
	pass

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
		var center : Array[Node2D] = []
		center.append_array(criteria_collider.get_center_overlapping())
		for node in center:
			if(node.get_parent() == self):
				center.erase(node)
				break
		return placement_criteria.check_criteria(above,left,below,right,center)
