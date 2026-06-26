class_name SaveLoadManager extends Node

var save_file : FileAccess

static var  extension : String = ".aeroscape"
static var saves_location : String = "user://aeroscapes"

var loading_file_path : String = ""

func _ready() -> void:
	var dir : DirAccess = DirAccess.open("user://")
	if(!dir.dir_exists(saves_location)):
		dir.make_dir(saves_location)

func settings_save_file_exists() -> bool:
	return FileAccess.file_exists("user://settings.save")

func start_load_saved_file(file_path : String):
	var fade_to_black = get_tree().get_first_node_in_group("fade_to_black")
	var callback_node = load("res://interface/load_file_callback.tscn").instantiate()
	fade_to_black.add_child(callback_node)
	fade_to_black.fade_in()
	var cursor : Cursor =  get_tree().get_first_node_in_group("cursor")
	cursor.set_inactive()
	loading_file_path = file_path

func commence_loading_saved_file():
	var zero_volume : float = -60
	AudioServer.set_bus_volume_db(0,zero_volume)
	#TODO loading spinner on separate thread

func load_aeroscape(file_path : String):
	var temp_vol = AudioServer.get_bus_volume_db(0)
	var zero_volume : float = -60
	AudioServer.set_bus_volume_db(0,zero_volume)
	var grid_base : Grid_Base = get_tree().get_first_node_in_group("grid_base")
	grid_base.clear_grid()
	save_file = FileAccess.open(file_path, FileAccess.READ)
	while(save_file.get_position() < save_file.get_length()):
		var line = save_file.get_line()
		var dictionary : Dictionary = JSON.parse_string(line)
		var type = String(dictionary.get("type"))
		match type:
			"grid_entity":
				load_grid_entity(dictionary)
			"tree":
				load_tree(dictionary)
	save_file.close()
	grid_base.update()
	AudioServer.set_bus_volume_db(0,temp_vol)

func save_aeroscape(file_name : String): 
	var path = str(str("user://aeroscapes/",file_name),".aeroscape")
	save_file= FileAccess.open(path, FileAccess.WRITE)
	save_grid_entities()
	save_file.close()

func save_grid_entities():
	save_stones()
	save_nonsolid_stones()
	save_plants()
	save_chimes()
	save_musicians()
	save_machines()
	save_water()

func save_stones():
	var entities = get_tree().get_nodes_in_group("stone")
	save_entities(entities)

func save_nonsolid_stones():
	var entities = get_tree().get_nodes_in_group("stone_nonsolid")
	save_entities(entities)

func save_chimes():
	var entities = get_tree().get_nodes_in_group("chime")
	save_entities(entities)

func save_musicians():
	var entities = get_tree().get_nodes_in_group("musician")
	save_entities(entities)

func save_machines():
	var entities = get_tree().get_nodes_in_group("machine")
	save_entities(entities)

func save_water():
	var entities = get_tree().get_nodes_in_group("water_fall")
	save_entities(entities)

func save_entities(entities : Array[Node]):
	for entity : Grid_Entity in entities:
		if(entity.get_packedscene_path() != ""):
			var save_dictionary : Dictionary = get_grid_entity_dictionary(entity)
			save_file.store_line(JSON.stringify(save_dictionary))

func get_grid_entity_dictionary(entity : Grid_Entity) -> Dictionary:
	var grid_entity_dictionary : Dictionary = {
		"type" : "grid_entity",
		"pos_x" : entity.global_position.x,
		"pos_y" : entity.global_position.y,
		"packedscene_path" : entity.get_packedscene_path()
	}
	return grid_entity_dictionary

func load_grid_entity(dictionary : Dictionary) -> Node:
	var path : String = dictionary.get("packedscene_path")
	var pos_x = dictionary.get("pos_x")
	var pos_y = dictionary.get("pos_y")
	var instance = instantiate_grid_entity(path, Vector2(pos_x,pos_y))
	return instance

func instantiate_grid_entity(packedscene_path : String, pos : Vector2) -> Node:
	var packed_scene = load(packedscene_path)
	var instance : Grid_Entity = packed_scene.instantiate()
	instance.set_is_loaded()
	var grid_sandbox = get_tree().get_first_node_in_group("grid_sandbox")
	grid_sandbox.add_child(instance)
	instance.global_position = pos
	var grid_base : Grid_Base = get_tree().get_first_node_in_group("grid_base")
	grid_base.update()
	return instance

func load_tree(dictionary : Dictionary):
	var tree : Plant_Tree = load_grid_entity(dictionary)
	tree.load_from_dictionary(dictionary)

func save_plants():
	save_trees()
	save_grass()
	save_vines()
	save_bushes()

func save_grass():
	var entities = get_tree().get_nodes_in_group("grass")
	save_entities(entities)

func save_vines():
	var entities = get_tree().get_nodes_in_group("vine")
	save_entities(entities)

func save_bushes():
	var entities = get_tree().get_nodes_in_group("bush")
	save_entities(entities)

func save_trees():
	var entities = get_tree().get_nodes_in_group("tree_trunk")
	for entity : Plant_Tree in entities:
		var save_dictionary : Dictionary = entity.get_save_dictionary()
		save_file.store_line(JSON.stringify(save_dictionary))
