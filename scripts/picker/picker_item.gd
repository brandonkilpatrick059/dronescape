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

func get_place_criteria() -> Place_Criteria:
	return place_criteria

func check_criteria(above : Array[Node2D], left : Array[Node2D],
below : Array[Node2D], right : Array[Node2D], center : Array[Node2D]) -> bool:
	if(place_criteria == null):
		return true
	else:
		return place_criteria.check_criteria(above,left,below,right,center)
