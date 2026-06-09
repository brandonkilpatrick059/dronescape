@tool
class_name Stone extends Grid_Entity

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

var grid_x : int = 0
var grid_y : int = 0

var mouse_over : bool = false

func _ready() -> void:
	grid_entity_init()
	add_to_group("stone")

func set_grid_pos(x : int, y : int):
	grid_x = x
	grid_y = y

func get_grid_x() -> int:
	return grid_x

func get_grid_y() -> int:
	return grid_y

func get_grid_vector() -> Vector2:
	return Vector2(grid_x, grid_y)

func set_animation(name : String):
	sprite.play(name)

func set_stone_collision(name : String):
	if(name.contains("center")):
		$StaticBody2D/center.disabled = false
		$StaticBody2D/top_left.disabled = true
		$StaticBody2D/top_right.disabled = true
		$StaticBody2D/bottom_left.disabled = true
		$StaticBody2D/bottom_right.disabled = true
		$StaticBody2D/center.visible = true
		$StaticBody2D/top_left.visible = false
		$StaticBody2D/top_right.visible = false
		$StaticBody2D/bottom_left.visible = false
		$StaticBody2D/bottom_right.visible = false
	else:
		match(name):
			"top_left":
				$StaticBody2D/center.disabled = true
				$StaticBody2D/top_left.disabled = false
				$StaticBody2D/top_right.disabled = true
				$StaticBody2D/bottom_left.disabled = true
				$StaticBody2D/bottom_right.disabled = true
				$StaticBody2D/center.visible = false
				$StaticBody2D/top_left.visible = true
				$StaticBody2D/top_right.visible = false
				$StaticBody2D/bottom_left.visible = false
				$StaticBody2D/bottom_right.visible = false
			"top_right":
				$StaticBody2D/center.disabled = true
				$StaticBody2D/top_left.disabled = true
				$StaticBody2D/top_right.disabled = false
				$StaticBody2D/bottom_left.disabled = true
				$StaticBody2D/bottom_right.disabled = true
				$StaticBody2D/center.visible = false
				$StaticBody2D/top_left.visible = false
				$StaticBody2D/top_right.visible = true
				$StaticBody2D/bottom_left.visible = false
				$StaticBody2D/bottom_right.visible = false
			"bottom_right":
				$StaticBody2D/center.disabled = true
				$StaticBody2D/top_left.disabled = true
				$StaticBody2D/top_right.disabled = true
				$StaticBody2D/bottom_left.disabled = true
				$StaticBody2D/bottom_right.disabled = false
				$StaticBody2D/center.visible = false
				$StaticBody2D/top_left.visible = false
				$StaticBody2D/top_right.visible = false
				$StaticBody2D/bottom_left.visible = false
				$StaticBody2D/bottom_right.visible = true
			"bottom_left":
				$StaticBody2D/center.disabled = true
				$StaticBody2D/top_left.disabled = true
				$StaticBody2D/top_right.disabled = true
				$StaticBody2D/bottom_left.disabled = false
				$StaticBody2D/bottom_right.disabled = true
				$StaticBody2D/center.visible = false
				$StaticBody2D/top_left.visible = false
				$StaticBody2D/top_right.visible = false
				$StaticBody2D/bottom_left.visible = true
				$StaticBody2D/bottom_right.visible = false

func _on_static_body_2d_mouse_entered() -> void:
	#var cursor = get_tree().get_first_node_in_group("cursor")
	#cursor.global_position = global_position
	#cursor.visible = true
	mouse_over = true

func cursor_destroy():
	queue_free()

func _on_static_body_2d_mouse_exited() -> void:
	mouse_over = false
