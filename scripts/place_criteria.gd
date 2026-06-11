class_name Place_Criteria extends Node

@export var above_requires_groups : Array[String] = []
@export var left_requires_groups : Array[String] = []
@export var below_requires_groups : Array[String] = []
@export var right_requires_groups : Array[String] = []
@export var above_excludes_groups : Array[String] = []
@export var left_excludes_groups : Array[String] = []
@export var below_excludes_groups : Array[String] = []
@export var right_excludes_groups : Array[String] = []

func check_criteria(above : Array[Node2D], left : Array[Node2D],
below : Array[Node2D], right : Array[Node2D]) -> bool:
		var has_all_required_groups = true
		has_all_required_groups = (has_all_required_groups && 
		check_direction_criteria(above,above_requires_groups))
		has_all_required_groups = (has_all_required_groups && 
		check_direction_criteria(left,left_requires_groups))
		has_all_required_groups = (has_all_required_groups &&
		check_direction_criteria(below,below_requires_groups))
		has_all_required_groups = (has_all_required_groups &&
		check_direction_criteria(right,right_requires_groups))
		var exclude_mode = true
		var no_excluded_groups = true
		no_excluded_groups = (no_excluded_groups && 
		check_direction_criteria(above,above_excludes_groups,exclude_mode))
		no_excluded_groups = (no_excluded_groups && 
		check_direction_criteria(left,left_excludes_groups,exclude_mode))
		no_excluded_groups = (no_excluded_groups && 
		check_direction_criteria(below,below_excludes_groups,exclude_mode))
		no_excluded_groups = (no_excluded_groups && 
		check_direction_criteria(right,right_excludes_groups,exclude_mode))
		var passes_criteria = (has_all_required_groups && no_excluded_groups)
		return passes_criteria

func check_direction_criteria(nodes : Array[Node2D], requires_groups : Array[String], 
exclude_mode : bool = false) -> bool:
	var meets_requirements = true
	if(requires_groups.size() > 0 && nodes.size() == 0 && !exclude_mode):
		meets_requirements = false
	else:
		for group in requires_groups:
			for node in nodes:
				if(exclude_mode):
					if(node.get_parent().is_in_group(group)):
						meets_requirements = false
						break
				else:
					if(!node.get_parent().is_in_group(group)):
						meets_requirements = false
						break
			if(!meets_requirements):
				break
	return meets_requirements
