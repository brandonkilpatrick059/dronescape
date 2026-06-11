@tool
class_name Picker_Item extends Node2D

@export var display_sprite_frames : SpriteFrames = null
@export var display_animation : String = ""
@export var item : PackedScene = null
@export var tab_path : String = ""
@export var place_criteria : Place_Criteria = null

func get_display_sprite_frames() -> SpriteFrames:
	return display_sprite_frames

func get_display_animation() -> String:
	return display_animation

func get_item() -> PackedScene:
	return item

func get_tab_path() -> String:
	return tab_path

func check_criteria(above : Array[Node], left : Array[Node],
below : Array[Node], right : Array[Node]) -> bool:
	if(place_criteria == null):
		return true
	else:
		return place_criteria.check_criteria(above,left,below,right)
