extends Label

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	text = str(Engine.get_frames_per_second())
	if(Input.is_action_just_pressed("dev_2")):
		visible = !visible
	
