@tool
class_name Grid_Base extends Node2D

static var grid_size : int = 16

var grid_entities : Array[Node]
var stones : Array[Node]
var stones_nonsolid : Array[Node]

var initialized = false

var timer := Timer.new()

func _ready() -> void:
	timer.one_shot = true
	add_child(timer)

func load_default_preset():
	var save_load_manager : SaveLoadManager = get_tree().get_first_node_in_group("save_load_manager")
	save_load_manager.load_aeroscape("res://presets/simple_island.txt")

func initialize_grid():
	load_default_preset()

func update():
	update_orientations("stone")
	update_orientations("stone_nonsolid")
	update_orientations("vine")
	update_orientations("grass")
	var musician_manager : Musician_Manager = get_tree().get_first_node_in_group("musician_manager")
	musician_manager.update_musicians()

func clear_grid():
	var grid_entities = get_tree().get_nodes_in_group("grid_entity")
	for entity in grid_entities:
		entity.queue_free()

func update_orientations(group : String):
	var update_entitys : Array[Node] = get_tree().get_nodes_in_group(group)
	for entity in update_entitys:
		var pos_above :Vector2 = entity.global_position + Vector2(0,-grid_size)
		var pos_below :Vector2 = entity.global_position + Vector2(0,grid_size)
		var pos_left :Vector2 = entity.global_position + Vector2(-grid_size,0)
		var pos_right :Vector2 = entity.global_position + Vector2(grid_size,0)
		var entity_above : bool = false
		var entity_below : bool = false
		var entity_right : bool = false
		var entity_left : bool = false
		for check_entity in update_entitys:
			if(check_entity.global_position == pos_above):
				entity_above = true
			elif(check_entity.global_position == pos_below):
				entity_below = true
			elif(check_entity.global_position == pos_left):
				entity_left = true
			elif(check_entity.global_position == pos_right):
				entity_right = true
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
		entity.set_orientation(animation_name)

func _physics_process(delta: float) -> void:
	if(timer.is_stopped()):
		update()
		timer.start(0.1)

func _process(delta: float) -> void:
	if(!initialized):
		initialized = true
		initialize_grid()
