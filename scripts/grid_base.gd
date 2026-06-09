@tool
class_name Grid_Base extends Node2D

static var grid_size : int = 16

var grid_entities : Array[Node]
var stones : Array[Node]

var initialized = false

func _ready() -> void:
	pass


func initialize_grid():
	grid_entities = get_tree().get_nodes_in_group("grid_entity")
	update()

func update():
	update_stones()

func update_stones():
	stones = get_tree().get_nodes_in_group("stone")
	for stone in stones:
		var pos_above :Vector2 = stone.global_position + Vector2(0,-grid_size)
		var pos_below :Vector2 = stone.global_position + Vector2(0,grid_size)
		var pos_left :Vector2 = stone.global_position + Vector2(-grid_size,0)
		var pos_right :Vector2 = stone.global_position + Vector2(grid_size,0)
		var stone_above : bool = false
		var stone_below : bool = false
		var stone_right : bool = false
		var stone_left : bool = false
		for check_stone in stones:
			if(check_stone.global_position == pos_above):
				stone_above = true
			elif(check_stone.global_position == pos_below):
				stone_below = true
			elif(check_stone.global_position == pos_left):
				stone_left = true
			elif(check_stone.global_position == pos_right):
				stone_right = true
		var animation_name = "center_center"
		if(stone_right && stone_above && !stone_left && stone_below):
			animation_name = "center_left"
		elif(!stone_right && stone_above && stone_left && stone_below):
			animation_name = "center_right"
		elif(!stone_right && stone_left && !stone_below):
			animation_name = "bottom_right"
		elif(stone_right && !stone_left && !stone_below):
			animation_name = "bottom_left"
		elif(stone_right && !stone_above && !stone_left && stone_below):
			animation_name = "top_left"
		elif(!stone_right && !stone_above && stone_left && stone_below):
			animation_name = "top_right"
		elif(stone_above && !stone_below):
			animation_name = "bottom_center"
		elif(!stone_above && stone_below):
			animation_name = "top_center"
		stone.set_animation(animation_name)

func _process(delta: float) -> void:
	if(!initialized):
		initialized = true
		initialize_grid()
