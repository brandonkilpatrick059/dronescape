@tool
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

var return_tab : bool = false

var grid_entity : PackedScene = null
var tab_path : String = ""
var picker_item : Node

var last_frame : int = 0

var menu_tab : bool = false

var process_node_ref : Node = null

@export var is_picker : bool = false

func _ready() -> void:
	retracted = true
	animated_sprite.play("retracted")
	audio_player.bus = "interface"
	if(not is_picker):
		var process_node = load("res://interface/picker/picker_bubble_process.tscn")
		process_node_ref = process_node.instantiate()
		add_child(process_node_ref)

func handle_input():
	if(Input.is_action_just_released("main_action")):
		if(mouse_over && active):
			var picker_circle : Picker_Circle = get_tree().get_first_node_in_group("picker_circle")
			audio_player.stream = load("res://audio/interface/click.ogg")
			if(menu_tab):
				audio_player.play()
				picker_circle.open_menu()
			elif(return_tab):
				picker_circle.location_to_prev()
				audio_player.play()
			elif(tab_path != ""):
				audio_player.play()
				picker_circle.set_web_location(tab_path)
			elif(grid_entity != null):
				audio_player.play()
				var cursor : Cursor = get_tree().get_first_node_in_group("cursor")
				cursor.set_create_grid_entity(grid_entity)
				var set_picker_item = get_picker_item()
				cursor.set_picker_node(set_picker_item)
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
	if(expanding && (animated_sprite.frame == expanding_frames ||
	animated_sprite.frame < last_frame)):
		animated_sprite.play("default")
		expanding = false
		expanded = true
	
	var retracting_frames : int = animated_sprite.sprite_frames.get_frame_count("retract") - 1
	if(retracting && (animated_sprite.frame == retracting_frames||
	animated_sprite.frame < last_frame)):
		animated_sprite.play("retracted")
		retracting = false
		retracted = true
	last_frame = animated_sprite.frame

func set_display(spriteframes : SpriteFrames, animation : String):
	display.sprite_frames = spriteframes
	display.play(animation)

func clear_display():
	grid_entity = null
	tab_path = ""
	return_tab = false
	display.sprite_frames = null

func set_active():
	active = true

func set_inactive():
	active = false
	grid_entity = null

func set_grid_entity(scene : PackedScene):
	grid_entity = scene

func get_grid_entity() -> PackedScene:
	return grid_entity

func set_tab_path(path : String):
	tab_path = path

func _on_area_2d_mouse_entered() -> void:
	mouse_over = true

func _on_area_2d_mouse_exited() -> void:
	mouse_over = false

func set_picker_item(node : Node):
	picker_item = node

func get_picker_item() -> Node:
	return picker_item

func set_menu_tab(set_val : bool):
	menu_tab = set_val

func set_return_tab(set_val : bool):
	clear_display()
	return_tab = set_val
	if(return_tab):
		set_display(load("res://sprites/interface/tabs.tres"),"return")
