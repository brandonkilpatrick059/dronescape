extends Area2D

@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D



func handle_input():
	if(Input.is_action_just_pressed("main_action")):
		spawn_grid_entity()
	elif(Input.is_action_just_pressed("second_action")):
		delete_targeted()
	elif(Input.is_action_just_pressed("third_action")):
		create_picker()

func play_stream(stream_path : String):
	audio_player.stream = load(stream_path)
	audio_player.play()

func create_picker():
	var num_pickers : int = get_tree().get_nodes_in_group("picker_circle").size()
	if(num_pickers == 0):
		var circle = load("res://interface/picker_circle.tscn").instantiate()
		get_parent().add_child(circle)
		circle.global_position = global_position

func delete_targeted():
	var bodies: Array[Node2D] = get_overlapping_bodies()
	if(bodies.size() > 0):
		var target = bodies[0].get_parent() #body is child of grid_entity
		if(target.is_in_group("grid_entity")):
			target.cursor_destroy()
			update_grid_base()
			play_stream("res://audio/interface/brush_snare.ogg")

func spawn_grid_entity():
	var bodies: Array[Node2D] = get_overlapping_bodies()
	if(bodies.size() == 0):
		var stone = load("res://entities/stones/purple_brick.tscn").instantiate()
		get_parent().add_child(stone)
		stone.global_position = global_position
		update_grid_base()
		var drum = randi_range(1,3)
		play_stream(str(str("res://audio/interface/drum/",drum),".ogg"))

func update_grid_base():
	var grid_base = get_tree().get_first_node_in_group("grid_base")
	grid_base.update()

func fade_near_picker_circle():
	var picker_circle = get_tree().get_first_node_in_group("picker_circle")
	if(picker_circle != null):
		var distance_to_circle = global_position.distance_to(picker_circle.global_position)
		var fade_min_distance = 256
		if(distance_to_circle < fade_min_distance):
			var fade_fraction = 1 - ((fade_min_distance - distance_to_circle) / fade_min_distance)
			modulate = Color(1,1,1,fade_fraction)
		else:
			modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,1,1,1)
		

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var grid_position = mouse_pos
	var grid_size_vect : Vector2 = Vector2(Grid_Base.grid_size,Grid_Base.grid_size)
	global_position = grid_position.snapped(grid_size_vect)
	fade_near_picker_circle()
	
	
	handle_input()
