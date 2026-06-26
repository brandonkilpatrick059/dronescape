extends Node2D

#this is used to fade out the camera and start the loading 
#message before loading actually begins. Monitors the fade_to_black
#node (this node's parent) and then calls back to save_load_manager
#once it detects the screen is fully dark

func _physics_process(delta: float) -> void:
	if(get_parent().is_faded_in()):
		var save_load_manager : SaveLoadManager = get_tree().get_first_node_in_group("save_load_manager")
		save_load_manager.commence_loading_saved_file()
		queue_free()
