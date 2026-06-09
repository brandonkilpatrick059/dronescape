extends Node2D

var current_alpha = 0.0

@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

var timer := Timer.new()

var fading_in : bool = false
var fading_out : bool = false
var active : bool = false

func _ready() -> void:
	modulate = Color(1,1,1,0)
	timer.one_shot = true
	add_child(timer)
	audio_player.stream = load("res://audio/interface/picker_circle.ogg")
	audio_player.play()
	fading_in = true

func handle_input():
	if(Input.is_action_just_pressed("third_action")):
		if(active):
			active = false
			fading_out = true
			audio_player.play()

func _physics_process(delta: float) -> void:
	handle_input()
	if(timer.is_stopped()):
		var alpha_step = 0.01
		if(fading_in && current_alpha < 1.0):
			current_alpha = current_alpha + alpha_step
		elif(fading_in && current_alpha >= 1.0):
			fading_in = false
			active = true
		elif(fading_out && current_alpha > 0.0):
			current_alpha = current_alpha - alpha_step
		elif(fading_out && current_alpha <= 0.0):
			queue_free()
		modulate = Color(1,1,1, current_alpha)
	
