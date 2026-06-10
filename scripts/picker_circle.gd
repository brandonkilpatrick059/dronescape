class_name Picker_Circle extends Node2D

var current_alpha = 0.0

@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

@onready var display_items : Node = $display_items
@onready var picker_web : Picker_Web = $PickerWeb
var web_location = "picker_center"

@onready var bubble_0 = $PickerBubble
@onready var bubble_1 = $PickerBubble2
@onready var bubble_2 = $PickerBubble3
@onready var bubble_3 = $PickerBubble4
@onready var bubble_4 = $PickerBubble5
@onready var bubble_5 = $PickerBubble6
@onready var bubble_6 = $PickerBubble7
@onready var bubble_7 = $PickerBubble8
@onready var bubble_8 = $PickerBubble9
var picker_bubbles : Array[Node2D]

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
	picker_bubbles = [
		bubble_0, bubble_1, bubble_2,
		bubble_3, bubble_4, bubble_5,
		bubble_6, bubble_7, bubble_8
	]
	set_web_location(web_location)

func handle_input():
	if(Input.is_action_just_pressed("third_action")):
		if(active):
			disappear()

func disappear():
	set_inactive()
	fading_out = true
	audio_player.play()

func activate_bubbles():
	for bubble in picker_bubbles:
		bubble.set_active()

func deactivate_bubbles():
	for bubble in picker_bubbles:
		bubble.set_inactive()

func set_active():
	active = true
	activate_bubbles()
	update_display_items()

func set_inactive():
	active = false
	deactivate_bubbles()

func update_display_items():
	for bubble : Picker_Bubble in picker_bubbles:
		if(bubble != bubble_0):
			bubble.clear_display()
	
	var web_node : Picker_Web_Node = get_tree().get_first_node_in_group(web_location)
	var items : Array[Node] = web_node.get_display_items()
	var index = 1
	for item : Picker_Item in items:
		if(index < picker_bubbles.size()):
			var bubble : Picker_Bubble = picker_bubbles[index]
			var anim_path = item.get_display_sprite_frames()
			var anim_name = item.get_display_animation()
			var entity_path = item.get_item_path()
			var tab_path = item.get_tab_path()
			bubble.set_display(anim_path,anim_name) 
			bubble.set_grid_entity_path(entity_path)
			bubble.set_tab_path(tab_path)
			bubble.set_picker_item(item)
			index = index + 1

func set_web_location(location : String):
	web_location = location
	var web_node : Picker_Web_Node = get_tree().get_first_node_in_group(web_location)
	if(web_node.get_prev_web_location() != ""):
		bubble_0.set_return_tab(true)
	else:
		var cursor : Cursor = get_tree().get_first_node_in_group("cursor")
		var item = cursor.get_picker_node()
		var anim_path = item.get_display_sprite_frames()
		var anim_name = item.get_display_animation()
		var entity_path = item.get_item_path()
		var tab_path = item.get_tab_path()
		bubble_0.set_return_tab(false)
		bubble_0.set_display(anim_path,anim_name) 
		bubble_0.set_grid_entity_path(entity_path)
		bubble_0.set_tab_path(tab_path)
		bubble_0.set_picker_item(item)
	update_display_items()

func location_to_prev():
	var web_node : Picker_Web_Node = get_tree().get_first_node_in_group(web_location)
	var prev_location = web_node.get_prev_web_location()
	if(prev_location != ""):
		set_web_location(prev_location)

func _physics_process(delta: float) -> void:
	handle_input()
	if(timer.is_stopped()):
		var alpha_step = 0.04
		if(fading_in && current_alpha < 1.0):
			current_alpha = current_alpha + alpha_step
		elif(fading_in && current_alpha >= 1.0):
			fading_in = false
			set_active()
		elif(fading_out && current_alpha > 0.0):
			current_alpha = current_alpha - alpha_step
		elif(fading_out && current_alpha <= 0.0):
			queue_free()
		modulate = Color(1,1,1, current_alpha)
	
