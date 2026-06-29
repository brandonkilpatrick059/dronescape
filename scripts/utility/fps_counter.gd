extends Label

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	text = str(Engine.get_frames_per_second())
	var menu = get_tree().get_first_node_in_group("menu")
	if(not menu.is_active()):
		if(Input.is_action_just_pressed("dev_2")):
			visible = !visible
