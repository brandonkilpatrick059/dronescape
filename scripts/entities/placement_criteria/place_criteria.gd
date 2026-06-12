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
		check_required_groups(above,above_requires_groups))
		has_all_required_groups = (has_all_required_groups && 
		check_required_groups(left,left_requires_groups))
		has_all_required_groups = (has_all_required_groups &&
		check_required_groups(below,below_requires_groups))
		has_all_required_groups = (has_all_required_groups &&
		check_required_groups(right,right_requires_groups))
		var exclude_mode = true
		var no_excluded_groups = true
		no_excluded_groups = (no_excluded_groups && 
		check_excluded_groups(above,above_excludes_groups))
		no_excluded_groups = (no_excluded_groups && 
		check_excluded_groups(left,left_excludes_groups))
		no_excluded_groups = (no_excluded_groups && 
		check_excluded_groups(below,below_excludes_groups))
		no_excluded_groups = (no_excluded_groups && 
		check_excluded_groups(right,right_excludes_groups))
		var passes_criteria = (has_all_required_groups && no_excluded_groups)
		return passes_criteria

#func check_direction_criteria(nodes : Array[Node2D], requires_groups : Array[String], 
#exclude_mode : bool = false) -> bool:
	#var meets_requirements = true
		
	#if(requires_groups.size() > 0 && nodes.size() == 0 && !exclude_mode):
		#meets_requirements = false
	#else:
		#for group in requires_groups:
			#for node in nodes:
				#var group_found = false
				#if(exclude_mode):
					#if(node.get_parent().is_in_group(group)):
						#meets_requirements = false
				#else:
					#if(node.get_parent().is_in_group(group)):
						#group_found = true
						#meets_requirements = meets_requirements && group_found
	#return meets_requirements

func check_required_groups(nodes : Array[Node2D], requires_groups : Array[String]) -> bool:
	var meets_requirements = true
	if(requires_groups.size() > 0 && nodes.size() == 0):
		meets_requirements = false
	else:
		for group in requires_groups:
			var group_found = false
			for node in nodes:
				if(node.get_parent().is_in_group(group)):
					group_found = true
			meets_requirements = meets_requirements && group_found
	if(!meets_requirements):
		var test = 0
	return meets_requirements

func check_excluded_groups(nodes : Array[Node2D], excludes_groups : Array[String]) -> bool:
	var meets_requirements = true
	for group in excludes_groups:
		for node in nodes:
			if(node.get_parent().is_in_group(group)):
				meets_requirements = false
				break
		if(!meets_requirements):
			break
	if(!meets_requirements):
		var test = 0
	return meets_requirements
