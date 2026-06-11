class_name Cursor extends Area2D

@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collider : CollisionShape2D = $CollisionShape2D
@onready var above_collider : Area2D = $above
@onready var left_collider : Area2D = $left
@onready var below_collider : Area2D = $below
@onready var right_collider : Area2D = $right
@onready var criteria_collider : Criteria_Collider = $criteria_collider

var picker_circle_occlusion_distance = 128

var active : bool = false

var create_grid_entity : PackedScene = load("res://entities/stones/purple_stone.tscn")

var current_picker_node : Picker_Item = null

var can_place_entity : bool = true

func _ready() -> void:
	var purple_stone_pick = load("res://interface/picker/picker_items/stones/picker_item_purple_stone.tscn")
	current_picker_node = purple_stone_pick.instantiate()

func handle_input():
	if(Input.is_action_just_pressed("main_action")):
		spawn_grid_entity()
	elif(Input.is_action_just_pressed("second_action")):
		delete_targeted()
	elif(Input.is_action_just_pressed("third_action")):
		create_picker()

func set_create_grid_entity(scene : PackedScene):
	create_grid_entity = scene

func play_stream(stream_path : String):
	audio_player.stream = load(stream_path)
	audio_player.play()

func get_picker_node() -> Picker_Item:
	return current_picker_node

func set_picker_node(picker_node : Picker_Item):
	current_picker_node.queue_free()
	current_picker_node = picker_node

func create_picker():
	if(active):
		var num_pickers : int = get_tree().get_nodes_in_group("picker_circle").size()
		if(num_pickers == 0):
			var circle = load("res://interface/picker/picker_circle.tscn").instantiate()
			get_parent().add_child(circle)
			circle.global_position = global_position
			set_inactive()

func delete_targeted():
	if(active):
		var bodies: Array[Node2D] = get_overlapping_bodies()
		if(bodies.size() > 0):
			var target = bodies[0].get_parent() #body is child of grid_entity
			if(target.is_in_group("grid_entity")):
				target.cursor_destroy()
				update_grid_base()
				play_stream("res://audio/interface/brush_snare.ogg")

func spawn_grid_entity():
	if(active):
		if(can_place_entity):
			var bodies: Array[Node2D] = get_overlapping_bodies()
			if(bodies.size() == 0):
				spawn_entity()
			else:
				var can_spawn : bool = true
				for body in bodies:
					if(body.is_in_group("solid")):
						false
				if(can_spawn):
					spawn_entity()
		else:
			play_stream("res://audio/interface/click.ogg")

func spawn_entity():
	var entity : Grid_Entity = create_grid_entity.instantiate()
	get_parent().add_child(entity)
	if(current_picker_node.get_place_criteria() != null &&
		entity.get_placement_criteria() == null):
		var criteria = current_picker_node.get_place_criteria().duplicate()
		entity.set_placement_criteria(criteria)
	entity.global_position = global_position
	update_grid_base()
	var drum = randi_range(1,3)
	play_stream(str(str("res://audio/interface/drum/",drum),".ogg"))

func update_grid_base():
	var grid_base = get_tree().get_first_node_in_group("grid_base")
	grid_base.update()

func get_distance_to_picker_circle():
	var picker_circle = get_tree().get_first_node_in_group("picker_circle")
	if(picker_circle != null):
		var distance_to_circle = global_position.distance_to(picker_circle.global_position)
		return distance_to_circle
	return picker_circle_occlusion_distance + 1

func fade_near_picker_circle():
	var picker_circle = get_tree().get_first_node_in_group("picker_circle")
	if(picker_circle != null):
		var distance_to_circle = global_position.distance_to(picker_circle.global_position)
		var fade_min_distance = picker_circle_occlusion_distance
		if(distance_to_circle < fade_min_distance):
			var fade_fraction = 1 - ((fade_min_distance - distance_to_circle) / fade_min_distance)
			modulate = Color(1,1,1,fade_fraction)
		else:
			modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,1,1,1)

func set_inactive():
	visible = false
	active = false

func set_active():
	visible = true
	active = true

func update_can_place_entity():
	var above : Array[Node2D] =  []
	above.append_array(criteria_collider.get_above_overlapping())
	var left : Array[Node2D] =  []
	left.append_array(criteria_collider.get_left_overlapping())
	var below : Array[Node2D] =  []
	below.append_array(criteria_collider.get_below_overlapping())
	var right : Array[Node2D] =  []
	right.append_array(criteria_collider.get_right_overlapping())
	can_place_entity = current_picker_node.check_criteria(above,left,below,right)

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var grid_position = mouse_pos
	var grid_size_vect : Vector2 = Vector2(Grid_Base.grid_size,Grid_Base.grid_size)
	global_position = grid_position.snapped(grid_size_vect)
	
	update_can_place_entity()
	if(can_place_entity):
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,0,0,1)
	
	handle_input()
