class_name Picker_Circle extends Node2D

var current_alpha = 0.0

@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

@onready var display_items : Node = $display_items

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
	var items : Array[Node] = display_items.get_children()
	var index = 1
	for item : Picker_Item in items:
		if(index < picker_bubbles.size()):
			var bubble : Picker_Bubble = picker_bubbles[index]
			var anim_path = item.get_display_sprite_frames()
			var anim_name = item.get_display_animation()
			var entity_path = item.get_item_path()
			bubble.set_display(anim_path,anim_name) 
			bubble.set_grid_entity_path(entity_path)
			index = index + 1

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
	
