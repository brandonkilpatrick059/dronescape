class_name SaveLoadManager extends Node

var save_file : FileAccess

func _ready() -> void:
	var dir : DirAccess = DirAccess.open("user://")
	if(!dir.dir_exists("user://aeroscapes")):
		dir.make_dir("user://aeroscapes")

func settings_save_file_exists() -> bool:
	return FileAccess.file_exists("user://settings.save")

func load_aeroscape(file_path : String):
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
	save_file.close()

func save_aeroscape(file_name : String): 
	var path = str(str("user://aeroscapes/",file_name),".aeroscape")
	save_file= FileAccess.open(path, FileAccess.WRITE)
	save_grid_entities()
	save_plants()
	save_file.close()

func save_grid_entities():
	var entities = get_tree().get_nodes_in_group("grid_entity")
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

func load_grid_entity(dictionary : Dictionary):
	var path : String = dictionary.get("packedscene_path")
	var packed_scene = load(path)
	var instance = packed_scene.instantiate()
	var pos_x = dictionary.get("pos_x")
	var pos_y = dictionary.get("pos_y")
	var grid_sandbox = get_tree().get_first_node_in_group("grid_sandbox")
	grid_sandbox.add_child(instance)
	instance.global_position = Vector2(pos_x,pos_y)
	var grid_base : Grid_Base = get_tree().get_first_node_in_group("grid_base")
	grid_base.update()

func save_plants():
	pass

func save_settings():
	#user settings
	var settings : Dictionary = get_settings_dictionary()
	var settings_file : FileAccess = FileAccess.open("user://settings.save", FileAccess.WRITE)
	settings_file.store_line(JSON.stringify(settings))
	
	#input map settings
	var input_map_manager = get_tree().get_first_node_in_group("input_map_manager")
	var current_mapping = input_map_manager.get_current_mapping()
	var keyboard_dictionary : Dictionary = current_mapping.get_keyboard_dictionary()
	var controller_dictionary : Dictionary = current_mapping.get_controller_dictionary()
	settings_file.store_line(JSON.stringify(keyboard_dictionary))
	settings_file.store_line(JSON.stringify(controller_dictionary))
	
	settings_file.close()

func get_settings_dictionary() -> Dictionary:
	var settings_dictionary = {
		"lighting_index" = SettingsVariables.lighting_index,
		"resolution_index" = SettingsVariables.resolution_index,
		"full_screen" = SettingsVariables.full_screen
	}
	return settings_dictionary
