class_name Cursor extends Area2D

@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

var picker_circle_occlusion_distance = 128

var active : bool = true

var create_grid_entity_path : String = "res://entities/stones/purple_stone.tscn"

var current_picker_node : Picker_Item = null

func handle_input():
	if(Input.is_action_just_pressed("main_action")):
		spawn_grid_entity()
	elif(Input.is_action_just_pressed("second_action")):
		delete_targeted()
	elif(Input.is_action_just_pressed("third_action")):
		create_picker()

func set_create_grid_entity_path(path : String):
	create_grid_entity_path = path

func play_stream(stream_path : String):
	audio_player.stream = load(stream_path)
	audio_player.play()

func get_picker_node() -> Picker_Item:
	return current_picker_node

func create_picker():
	var num_pickers : int = get_tree().get_nodes_in_group("picker_circle").size()
	if(num_pickers == 0):
		var circle = load("res://interface/picker/picker_circle.tscn").instantiate()
		get_parent().add_child(circle)
		circle.global_position = global_position

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
		var bodies: Array[Node2D] = get_overlapping_bodies()
		if(bodies.size() == 0):
			spawn_entity()
		else:
			delete_targeted()
			spawn_entity()

func spawn_entity():
	var entity = load(create_grid_entity_path).instantiate()
	get_parent().add_child(entity)
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

func set_invisible_if_picker_circle_exists():
	var picker_circle = get_tree().get_first_node_in_group("picker_circle")
	if(picker_circle != null):
		set_inactive() 
	else:
		set_active()

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var grid_position = mouse_pos
	var grid_size_vect : Vector2 = Vector2(Grid_Base.grid_size,Grid_Base.grid_size)
	global_position = grid_position.snapped(grid_size_vect)
	set_invisible_if_picker_circle_exists()
	handle_input()
