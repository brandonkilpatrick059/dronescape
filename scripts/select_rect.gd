class_name SelectRect extends Sprite2D

var active : bool = false

func _ready() -> void:
	disable()
	#var grid_size_vect : Vector2 = Vector2(Grid_Base.grid_size,Grid_Base.grid_size)
	#global_position = global_position.snapped(grid_size_vect)

func get_center_overlapping() -> Array[Node2D]:
	return $criteria_collider.get_center_overlapping()

func disable():
	visible = false
	active = false

func enable():
	visible = true
	active = true

#func check_criteria(criteria : Place_Criteria) -> bool:
	#pass #todo: implement?
