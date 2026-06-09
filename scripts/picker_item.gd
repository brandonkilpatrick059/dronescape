class_name Picker_Item extends Node2D

@export var display_sprite_frames : String = ""
@export var display_animation : String = ""
@export var item_path : String = ""

func get_display_sprite_frames() -> String:
	return display_sprite_frames

func get_display_animation() -> String:
	return display_animation

func get_item_path() -> String:
	return item_path
