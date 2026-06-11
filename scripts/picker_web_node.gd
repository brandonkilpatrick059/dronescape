@tool
class_name Picker_Web_Node extends Node2D

@onready var display_items : Node = $display_items
#@onready var center_item : Node = $center_item

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

@export var prev_web_node : String = ""

func _ready() -> void:
	picker_bubbles = [
		bubble_0, bubble_1, bubble_2,
		bubble_3, bubble_4, bubble_5,
		bubble_6, bubble_7, bubble_8
	]
	update_display_items()

func update_display_items():
	var items : Array[Node] = display_items.get_children()
	var index = 1
	for item : Picker_Item in items:
		if(index < picker_bubbles.size()):
			var bubble : Picker_Bubble = picker_bubbles[index]
			var animation = item.get_display_sprite_frames()
			var anim_name = item.get_display_animation()
			var entity = item.get_item()
			bubble.set_display(animation,anim_name) 
			bubble.set_grid_entity(entity)
			index = index + 1


func get_display_items() -> Array[Node]:
	return display_items.get_children()

func get_prev_web_location() -> String:
	return prev_web_node
