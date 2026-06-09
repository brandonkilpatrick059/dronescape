extends Camera2D

var scroll_speed = 1
var bob_max = 8
var bobbing_up = false

var timer := Timer.new()

func _ready() -> void:
	timer.one_shot = true
	add_child(timer)

func _physics_process(delta: float) -> void:
	if(timer.is_stopped()):
		if(bobbing_up && offset.y > -bob_max):
			offset += Vector2(0,-scroll_speed)
			timer.start(0.3)
		elif(bobbing_up && offset.y <= -bob_max):
			bobbing_up = false
			timer.start(randf_range(1.0,1.5))
		elif(!bobbing_up && offset.y < bob_max):
			offset += Vector2(0,scroll_speed)
			timer.start(0.3)
		elif(!bobbing_up && offset.y >= bob_max):
			bobbing_up = true
			timer.start(randf_range(1.0,1.5))
		
