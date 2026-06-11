class_name Place_Criteria extends Node

@export var above_requires_groups : Array[String] = []
@export var left_requires_groups : Array[String] = []
@export var below_requires_groups : Array[String] = []
@export var right_requires_groups : Array[String] = []
@export var above_excludes_groups : Array[String] = []
@export var left_excludes_groups : Array[String] = []
@export var below_excludes_groups : Array[String] = []
@export var right_excludes_groups : Array[String] = []

func check_criteria(above : Array[Node], left : Array[Node],
below : Array[Node], right : Array[Node]) -> bool:
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

func check_direction_criteria(nodes : Array[Node], requires_groups : Array[String], 
exclude_mode : bool = false) -> bool:
	var meets_requirements = true
	for group in requires_groups:
		for node in nodes:
			if(!exclude_mode):
				if(!node.is_in_group(group)):
					meets_requirements = false
					break
			else:
				if(node.is_in_group(group)):
					meets_requirements = false
					break
		if(!meets_requirements):
			break
	return meets_requirements
