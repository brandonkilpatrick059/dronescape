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

var select_rect : PackedScene = load("res://interface/select_rect.tscn")

var current_picker_node : Picker_Item = null

var can_place_entity : bool = true

var main_action_pressed : bool = false
var second_action_pressed : bool = false
var rectangle_selecting : bool = false
var rectangle_start : Vector2 = Vector2(0,0)
var rectangle_end : Vector2 = Vector2(0,0)
var rectangle_creating : bool = false
var rectangle_deleting : bool = false

var select_rects_pool : Array[Node] = []
var select_rects : Array[Node] = []

var prev_position : Vector2 = Vector2(0,0)

var initialized : bool = false

var select_rect_timer := Timer.new()

var input_lockout_timer := Timer.new()

const delete_target_order : Array[String] = [
		"machine",
		"musician",
		"chime",
		"prop",
		"water",
		"plant_growth",
		"plant",
		"stone",
		"stone_nonsolid"
	]

func _ready() -> void:
	var purple_stone_pick = load("res://interface/picker/picker_items/stones/picker_item_purple_stone.tscn")
	current_picker_node = purple_stone_pick.instantiate()
	prev_position = global_position
	select_rect_timer.one_shot = true
	add_child(select_rect_timer)
	input_lockout_timer.one_shot = true
	add_child(input_lockout_timer)
	input_lockout_timer.start(0.1)

func handle_input():
	if(is_active() && input_lockout_timer.is_stopped()):
		if(Input.is_action_just_pressed("main_action")):
			if(!rectangle_selecting):
				rectangle_start = global_position
				rectangle_creating = true
				rectangle_deleting = false
				main_action_pressed = true
		elif(Input.is_action_just_released("main_action")):
			main_action_pressed = false
			if(rectangle_selecting && rectangle_creating):
				if(can_place_entity):
					get_select_rects()
					for rect in select_rects:
						spawn_grid_entity(rect)
			else:
				spawn_grid_entity()
			rectangle_selecting = false
			clear_select_rects_pool()
		elif(Input.is_action_just_pressed("second_action")):
			if(!rectangle_selecting):
				rectangle_start = global_position
				rectangle_deleting = true
				rectangle_creating = false
				second_action_pressed = true
		elif(Input.is_action_just_released("second_action")):
			second_action_pressed = false
			delete_targeted()
			rectangle_selecting = false
			clear_select_rects_pool()

func is_active() -> bool:
	return active

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

func delete_targeted():
	if(active):
		if(rectangle_selecting && rectangle_deleting):
			var delete_bodies : Array[Node2D] = []
			for rect : SelectRect in get_select_rects():
				delete_bodies.append_array(rect.get_center_overlapping())
			for body in delete_bodies:
				if(body.get_parent().is_in_group("grid_entity")):
					body.get_parent().cursor_destroy()
			play_stream("res://audio/interface/brush_snare.ogg")
		else:
			var bodies: Array[Node2D] = get_overlapping_bodies()
			if(bodies.size() > 0):
				var target = get_delete_target(bodies)
				if(target != null && target.is_in_group("grid_entity")):
					target.cursor_destroy()
					play_stream("res://audio/interface/brush_snare.ogg")

func get_delete_target(bodies : Array[Node2D]):
	var return_body : Node2D = null
	for group in delete_target_order:
		for body in bodies:
			if(body.get_parent().is_in_group(group)):
				return_body = body.get_parent()
				break
		if(return_body != null):
			break
	return return_body

func spawn_grid_entity(select_rect : SelectRect = null):
	if(active):
		if(can_place_entity):
			if(select_rect == null):
				spawn_entity()
			else:
				spawn_entity(select_rect.global_position)
		else:
			play_stream("res://audio/interface/no_place.ogg")

func spawn_entity(create_pos : Vector2 = global_position):
	var entity = create_grid_entity.instantiate()
	get_parent().add_child(entity)
	if(current_picker_node.get_place_criteria() != null &&
		entity.get_placement_criteria() == null):
		var criteria = current_picker_node.get_place_criteria().duplicate()
		entity.set_placement_criteria(criteria)
	entity.global_position = create_pos
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
	main_action_pressed = false
	input_lockout_timer.start(0.1)

func set_active():
	visible = true
	active = true
	input_lockout_timer.start(0.1)

func clear_select_rects_pool():
	for rect in select_rects_pool:
		rect.disable()

func get_select_rect_from_pool() -> Node:
	var ret_rect = null
	for rect in select_rects_pool:
		if(not rect.get_active()):
			rect.enable()
			ret_rect = rect
			break
	return ret_rect

func get_select_rects() -> Array[Node]:
	select_rects.clear()
	for rect in select_rects_pool:
		if rect.get_active():
			select_rects.append(rect)
	return select_rects

func update_rectangle_select():
	if(main_action_pressed || second_action_pressed):
		if(global_position.distance_to(rectangle_start) > 0):
			clear_select_rects_pool()
			rectangle_selecting = true
			rectangle_end = global_position
			var x_step = Grid_Base.grid_size
			var y_step = Grid_Base.grid_size
			if(rectangle_end.x < rectangle_start.x):
				x_step = -x_step
			if(rectangle_end.y < rectangle_start.y):
				y_step = -y_step
			var x_pos = rectangle_start.x
			var y_pos = rectangle_start.y
			var max_x_steps = 8
			var max_y_steps = 8
			var x_steps = 0
			var y_steps = 0
			while(x_pos != rectangle_end.x + x_step && #add step to make it inclusiv
			x_steps < max_x_steps): 
				while(y_pos != rectangle_end.y + y_step &&
				y_steps < max_y_steps):
					var new_select_rect = get_select_rect_from_pool()
					if(rectangle_creating):
						new_select_rect.modulate = Color(0,1,0,0.5)
					elif(rectangle_deleting):
						new_select_rect.modulate = Color(1,0,0,0.5)
					new_select_rect.global_position = Vector2(x_pos,y_pos)
					select_rects.append(new_select_rect)
					y_pos = y_pos + y_step
					y_steps = y_steps + 1
				x_pos = x_pos + x_step
				x_steps = x_steps + 1
				y_pos = rectangle_start.y
				y_steps = 0
	else:
		rectangle_selecting = false
		clear_select_rects_pool()

func update_can_place_entity():
	if(not rectangle_selecting):
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
		can_place_entity = current_picker_node.check_criteria(above,left,below,right,center)
	elif(rectangle_selecting && rectangle_creating):
		get_select_rects()
		var can_place : bool = true
		for rect : SelectRect in select_rects:
			var rect_can_place : bool = rect.can_place_entity(current_picker_node)
			can_place = can_place && rect_can_place
		can_place_entity = can_place
		if(can_place_entity):
			set_select_rects_color(Color(0,1,0,0.5))
		else:
			set_select_rects_color(Color(0.5,0.5,0.0,0.5))

func set_select_rects_color(color : Color):
	for rect in select_rects:
		rect.modulate = color

func initialize_cursor():
	var index = 0
	var max_select_rects = 64
	while(index < max_select_rects):
		var new_rect = select_rect.instantiate()
		get_parent().add_child(new_rect)
		select_rects_pool.append(new_rect)
		index = index + 1

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var grid_position = mouse_pos
	var grid_size_vect : Vector2 = Vector2(Grid_Base.grid_size,Grid_Base.grid_size)
	var new_position : Vector2 = grid_position.snapped(grid_size_vect)
	if(prev_position != new_position):
		global_position = new_position
		prev_position = new_position
		if(select_rect_timer.is_stopped()):
			update_rectangle_select()
			select_rect_timer.start(0.006)
	if(can_place_entity):
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,0,0,1)
	
	handle_input()
	update_can_place_entity()
	if(not initialized):
		initialize_cursor()
		initialized = true
