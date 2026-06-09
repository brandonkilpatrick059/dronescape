class_name  Picker_Bubble extends Node2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer
@onready var display : AnimatedSprite2D = $display

var active = false

var mouse_over = false
var expanding = false
var retracting = false
var expanded = false
var retracted = true

var grid_entity_path : String = ""

func _ready() -> void:
	retracted = true
	animated_sprite.play("retracted")

func handle_input():
	if(Input.is_action_just_pressed("main_action")):
		if(mouse_over):
			audio_player.stream = load("res://audio/interface/click.ogg")
			audio_player.play()
			var cursor : Cursor = get_tree().get_first_node_in_group("cursor")
			cursor.set_create_grid_entity_path(grid_entity_path)
			var picker_circle : Picker_Circle = get_tree().get_first_node_in_group("picker_circle")
			picker_circle.disappear()

func handle_animation():
	if(active):
		if(mouse_over && retracted):
			animated_sprite.play("expand")
			expanding = true
			retracted = false
			audio_player.stream = load("res://audio/interface/picker_bubble.ogg")
			audio_player.play()
		elif(!mouse_over && expanded):
			animated_sprite.play("retract")
			expanding = false
			expanded = false
			retracting = true
		
		var expanding_frames : int = animated_sprite.sprite_frames.get_frame_count("expand") - 1
		if(expanding && animated_sprite.frame == expanding_frames):
			animated_sprite.play("default")
			expanding = false
			expanded = true
		
		var retracting_frames : int = animated_sprite.sprite_frames.get_frame_count("retract") - 1
		if(retracting && animated_sprite.frame == retracting_frames):
			animated_sprite.play("retracted")
			retracting = false
			retracted = true

func set_display(animation_path : String, animation : String):
	display.sprite_frames = load(animation_path)
	display.play(animation)

func set_active():
	active = true

func set_inactive():
	active = false

func set_grid_entity_path(path : String):
	grid_entity_path = path

func get_grid_entity_path() -> String:
	return grid_entity_path

func _physics_process(delta: float) -> void:
	handle_animation()
	handle_input()

func _on_area_2d_mouse_entered() -> void:
	mouse_over = true

func _on_area_2d_mouse_exited() -> void:
	mouse_over = false
