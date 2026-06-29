@tool
class_name Grid_Base extends Node2D

static var grid_size : int = 16

var grid_entities : Array[Node]
var stones : Array[Node]
var stones_nonsolid : Array[Node]

var initialized = false

var timer := Timer.new()

var orientables : Array[Node] = []
var orientables_index : int = 0
var updatables : Array[Node] = []
var updatables_index : int = 0

func _ready() -> void:
	timer.one_shot = true
	add_child(timer)

func load_default_preset():
	var save_load_manager : SaveLoadManager = get_tree().get_first_node_in_group("save_load_manager")
	save_load_manager.load_aeroscape("res://presets/simple_island.txt")

func initialize_grid():
	load_default_preset()

func update():
	if(!Engine.is_editor_hint()):
		#var orientables = get_tree().get_nodes_in_group("orientable")
		#for orientable in orientables:
			#orientable.orient_self()
		update_orientables()
		update_updatables()
		var musician_manager : Musician_Manager = get_tree().get_first_node_in_group("musician_manager")
		musician_manager.update_musicians()

func update_orientables():
	var orientables_processed_per_tick : int = 24
	var num_processed = 0
	orientables = get_tree().get_nodes_in_group("orientable")
	while(num_processed < orientables_processed_per_tick):
		if(orientables.size() > 0):
			if(orientables_index < orientables.size()):
				var process_node = orientables[orientables_index]
				if(process_node != null):
					process_node.orient_self()
				orientables_index = orientables_index + 1
			else:
				orientables_index = 0
		num_processed = num_processed + 1

func update_updatables():
	var updatables_processed_per_tick : int = 24
	var num_processed = 0
	updatables = get_tree().get_nodes_in_group("updatable")
	while(num_processed < updatables_processed_per_tick):
		if(updatables.size() > 0):
			if(updatables_index < updatables.size()):
				var process_node = updatables[updatables_index]
				if(process_node != null):
					process_node.update()
				updatables_index = updatables_index + 1
			else:
				updatables_index = 0
		num_processed = num_processed + 1

func clear_grid():
	var grid_entities = get_tree().get_nodes_in_group("grid_entity")
	for entity in grid_entities:
		entity.queue_free()

func _physics_process(delta: float) -> void:
	update()
	#if(timer.is_stopped()):
		#update()
		#timer.start(0.006)

func _process(delta: float) -> void:
	if(!initialized):
		initialized = true
		initialize_grid()
