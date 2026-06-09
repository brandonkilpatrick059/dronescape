class_name Wind_Manager extends Node2D

var timer := Timer.new()

var wind_particle = preload("res://wind/wind_particle.tscn")

func _ready() -> void:
	timer.one_shot = true
	add_child(timer)

func generate_wind():
	var height = 1280
	var point_step = 16
	var current_step = 0
	while(current_step < height):
		current_step = current_step + point_step
		var particle = wind_particle.instantiate()
		add_child(particle)
		particle.global_position = global_position + (Vector2(0,global_position.y + current_step))
		particle.launch(Vector2(10000,0))
	
func handle_input():
	if(Input.is_action_pressed("wind_right")):
		generate_wind()

func _physics_process(delta: float) -> void:
	if(timer.is_stopped()):
		handle_input()
		timer.start(0.5)
