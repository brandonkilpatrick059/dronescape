class_name SelectRect extends Sprite2D

var active : bool = false
@onready var criteria_collider = $criteria_collider

func _ready() -> void:
	disable()
	#var grid_size_vect : Vector2 = Vector2(Grid_Base.grid_size,Grid_Base.grid_size)
	#global_position = global_position.snapped(grid_size_vect)

func get_center_overlapping() -> Array[Node2D]:
	return criteria_collider.get_center_overlapping()

func get_active() -> bool:
	return active

func disable():
	visible = false
	active = false

func enable():
	visible = true
	active = true

func can_place_entity(picker_node : Picker_Item) -> bool:
	var above : Array[Node2D] =  []
	above.append_array(criteria_collider.get_above_overlapping())
	var left : Array[Node2D] =  []
	left.append_array(criteria_collider.get_left_overlapping())
	var below : Array[Node2D] =  []
	below.append_array(criteria_collider.get_below_overlapping())
	var right : Array[Node2D] =  []
	right.append_array(criteria_collider.get_right_overlapping())
	var center : Array[Node2D] =  []
	center.append_array(criteria_collider.get_center_overlapping())
	return picker_node.check_criteria(above,left,below,right,center)
