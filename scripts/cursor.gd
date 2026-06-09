extends Area2D

func handle_input():
	if(Input.is_action_just_pressed("main_action")):
		spawn_grid_entity()
	elif(Input.is_action_just_pressed("second_action")):
		delete_targeted()

func delete_targeted():
	var bodies: Array[Node2D] = get_overlapping_bodies()
	if(bodies.size() > 0):
		var target = bodies[0].get_parent() #body is child of grid_entity
		if(target.is_in_group("grid_entity")):
			target.cursor_destroy()
			update_grid_base()

func spawn_grid_entity():
	var bodies: Array[Node2D] = get_overlapping_bodies()
	if(bodies.size() == 0):
		var stone = load("res://entities/stones/purple_stone.tscn").instantiate()
		get_parent().add_child(stone)
		stone.global_position = global_position
		update_grid_base()

func update_grid_base():
	var grid_base = get_tree().get_first_node_in_group("grid_base")
	grid_base.update()

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var grid_position = mouse_pos
	var grid_size_vect : Vector2 = Vector2(Grid_Base.grid_size,Grid_Base.grid_size)
	global_position = grid_position.snapped(grid_size_vect)
	
	handle_input()
