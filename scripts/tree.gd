class_name Plant_Tree extends Grid_Entity

@export var max_height = 1

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var branch : PackedScene = preload("res://entities/plants/tree_1.tscn")
@onready var leaves_small : PackedScene = preload("res://entities/plants/leaves_1_small.tscn")
@onready var leaves_large : PackedScene = preload("res://entities/plants/leaves_1_large.tscn")
@onready var process_node : PackedScene = preload("res://entities/plants/tree_process.tscn")
@onready var growth_check_collider : Criteria_Collider = $criteria_collider
var timer := Timer.new()

var growth_level : int = 0
var is_trunk : bool = true

var growth_ref= null
var growth_created = false

var branch_points : Array[String] = []
var used_branch_points : Array[String]
var root_point : String = ""

var branches : Array[Plant_Tree] = []
var parent_branch : Plant_Tree = null

var distance_from_root = 0

var leaves_ref = null

var growth_wait_secs = 0.05

var trunk_ref : Plant_Tree = null

var num_forks = 0
var max_forks = 2

var branch_type : String = ""

var load_leaves : String = ""

const branch_types : Array[String] =[
		"branch_fork_right",
		"branch_fork_inv_from_left",
		"branch_fork_inv_from_right",
		"branch_fork_left",
		"branch_fork_up",
		"branch_bend_left",
		"branch_bend_right",
		"branch_inv_bend_left",
		"branch_inv_bend_right",
		"branc_straight_up",
		"branch_end",
]

func add_forks():
	num_forks = num_forks + 1

func get_forks():
	return num_forks

func _ready() -> void:
	grid_entity_init()
	timer.one_shot = true
	add_child(timer)
	timer.start(growth_wait_secs)
	if(is_trunk):
		branch_points.append("up")
		branch_type = "trunk_ground"
		sprite.play(branch_type)
		add_to_group("tree_trunk")
		trunk_ref = self
		if(not get_is_loaded()):
			var start_process = process_node.instantiate()
			add_child(start_process)

func set_trunk_ref (ref : Plant_Tree):
	trunk_ref = ref

func set_is_branch(in_distance : int, parent : Plant_Tree, trunk : Plant_Tree):
	distance_from_root = in_distance + 1
	is_trunk = false
	parent_branch = parent
	trunk_ref = trunk

func set_is_load_branch():
	is_trunk = false

func has_solid_bodies(bodies : Array[Node2D]):
	for body in bodies:
		if body.is_in_group("solid") || body.is_in_group("tree"):
			return true
	return false

func get_branch(new_root : String):
	root_point = new_root
	var bodies_left = growth_check_collider.get_left_overlapping()
	var bodies_right = growth_check_collider.get_right_overlapping()
	var bodies_up = growth_check_collider.get_above_overlapping()
	var solid_left = has_solid_bodies(bodies_left)
	var solid_right = has_solid_bodies(bodies_right)
	var solid_up = has_solid_bodies(bodies_up)
	var possible_branch_types : Array[String] = []
	if(root_point == "right"):
		possible_branch_types.append("branch_inv_bend_right")
		if(trunk_ref.get_forks() < max_forks):
			possible_branch_types.append("branch_fork_inv_from_right")
	elif(root_point == "left"):
		possible_branch_types.append("branch_inv_bend_left")
		if(trunk_ref.get_forks() < max_forks):
			possible_branch_types.append("branch_fork_inv_from_left")
	elif(root_point == "down"):
		possible_branch_types.append("branch_bend_left")
		possible_branch_types.append("branch_bend_right")
		if(trunk_ref.get_forks() < max_forks):
			possible_branch_types.append("branch_fork_up")
			possible_branch_types.append("branch_fork_left")
			possible_branch_types.append("branch_fork_right")
		possible_branch_types.append("branch_end")
		possible_branch_types.append("branch_straight_up")
		possible_branch_types.append("branch_straight_up") #to make it more likely
	if(solid_up):
		possible_branch_types = ["branch_end"]
	if(solid_left):
		possible_branch_types.erase("branch_bend_left")
		possible_branch_types.erase("branch_fork_inv_from_right")
		possible_branch_types.erase("branch_fork_up")
		possible_branch_types.erase("branch_fork_left")
	if(solid_right):
		possible_branch_types.erase("branch_bend_right")
		possible_branch_types.erase("branch_fork_inv_from_left")
		possible_branch_types.erase("branch_fork_up")
		possible_branch_types.erase("branch_fork_right")
	var num_possible : int = possible_branch_types.size() - 1
	var chosen_type : String = possible_branch_types[randi_range(0,num_possible)]
	if(possible_branch_types.has("branch_end") && distance_from_root >= trunk_ref.get_max_height()):
		chosen_type = "branch_end"
	match_branch_code(chosen_type)

func get_max_height():
	return max_height

func match_branch_code(code : String):
	match(code):
		"branch_fork_right":
			branch_fork_right()
		"branch_fork_inv_from_left":
			branch_fork_inv_from_left()
		"branch_fork_inv_from_right":
			branch_fork_inv_from_right()
		"branch_fork_left":
			branch_fork_left()
		"branch_fork_up":
			branch_fork_up()
		"branch_bend_left":
			branch_bend_left()
		"branch_bend_right":
			branch_bend_right()
		"branch_inv_bend_left":
			branch_inv_bend_left()
		"branch_inv_bend_right":
			branch_inv_bend_right()
		"branch_straight_up":
			branch_straight_up()
		"branch_end":
			branch_end()

func branch_fork_right():
	branch_type = "branch_fork_right"
	sprite.play(branch_type)
	root_point = "down"
	branch_points = ["up","right"]
	if(trunk_ref != null):
		trunk_ref.add_forks()

func branch_fork_inv_from_left():
	branch_type = "branch_fork_inv_from_left"
	sprite.play("branch_fork_inv")
	root_point = "left"
	branch_points = ["up","right"]
	if(trunk_ref != null):
		trunk_ref.add_forks()

func branch_fork_inv_from_right():
	branch_type = "branch_fork_inv_from_right"
	sprite.play("branch_fork_inv")
	root_point = "right"
	branch_points = ["up","right"]
	if(trunk_ref != null):
		trunk_ref.add_forks()

func branch_fork_left():
	branch_type = "branch_fork_left"
	sprite.play(branch_type)
	root_point = "down"
	branch_points = ["up","left"]
	if(trunk_ref != null):
		trunk_ref.add_forks()

func branch_fork_up():
	branch_type = "branch_fork_up"
	sprite.play(branch_type)
	root_point = "down"
	branch_points = ["right","left"]
	if(trunk_ref != null):
		trunk_ref.add_forks()

func branch_bend_left():
	branch_type = "branch_bend_left"
	sprite.play(branch_type)
	root_point = "down"
	branch_points = ["left"]

func branch_bend_right():
	branch_type = "branch_bend_right"
	sprite.play(branch_type)
	root_point = "down"
	branch_points = ["right"]

func branch_inv_bend_left():
	branch_type = "branch_inv_bend_left"
	sprite.play(branch_type)
	root_point = "left"
	branch_points = ["up"]

func branch_inv_bend_right():
	branch_type = "branch_inv_bend_right"
	sprite.play(branch_type)
	root_point = "right"
	branch_points = ["up"]

func branch_straight_up():
	branch_type = "branch_straight_up"
	sprite.play(branch_type)
	root_point = "down"
	branch_points = ["up"]

func branch_end():
	branch_type = "branch_end"
	sprite.play(branch_type)
	root_point = "down"
	branch_points = []
	if(leaves_ref == null):
		if(load_leaves != ""):
			match(load_leaves):
				"small":
					leaves_ref = leaves_small.instantiate()
					add_child(leaves_ref)
				"large":
					leaves_ref = leaves_large.instantiate()
					add_child(leaves_ref)
		elif(randf_range(0.0,1.0) < 0.5):
			leaves_ref = leaves_large.instantiate()
			add_child(leaves_ref)
		elif(randf_range(0.0,1.0) < 0.5):
			leaves_ref = leaves_small.instantiate()
			add_child(leaves_ref)

func set_orientation(name : String):
	sprite.play(name)

func queue_free_on_failed_placement_criteria():
	if(!check_criteria()):
		destroy_self_and_all_branches()

func is_branch_end() -> bool:
	if(branch_points.size() > 0):
		return false
	else:
		return true

func grow_branch(new_root : String):
	var new_branch = branch.instantiate()


func root_point_from_branch(branch_point : String) -> String:
	match branch_point:
		"up":
			return "down"
		"left":
			return "right"
		"right":
			return "left"
		"down":
			return "up"
		_:
			return ""

func set_load_leaves(leaves : String):
	load_leaves = leaves

func cursor_destroy():
	if(parent_branch != null):
		parent_branch.remove_child_branch(self)
	destroy_self_and_all_branches()

func destroy_self_and_all_branches():
	for branch in branches:
		branch.destroy_self_and_all_branches()
	queue_free()

func remove_child_branch(branch : Plant_Tree):
	branches.erase(branch)

func propogate_growth():
	if(is_branch_end()):
		get_branch(root_point_from_branch("up"))
	if(branch_points.size() > 0 &&
	branches.size() == 0):
		grow_branches()
	else:
		for branch in branches:
			branch.propogate_growth()

class save_data:
	var pos : Vector2 = Vector2(0,0)
	var branch_type : String = ""
	var leaves : String = ""

func get_save_data() -> Array[save_data]:
	var ret_data : Array[save_data] = []
	var data := save_data.new()
	data.pos = global_position
	data.branch_type = branch_type
	if(leaves_ref != null):
		data.leaves = leaves_ref.get_type()
	if(branch_type != "trunk_ground"):
		ret_data.append(data)
	for branch in branches:
		var new_data = branch.get_save_data()
		ret_data.append_array(new_data)
	return ret_data

func get_save_dictionary() -> Dictionary:
	var new_save_data : Array[save_data] = get_save_data()
	var save_dictionary : Dictionary = {
		"type" : "tree",
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"packedscene_path" : get_packedscene_path()
	}
	var branch_num = 0
	for branch : save_data in new_save_data:
		var branch_dictionary : Dictionary = {
			"pos_x" : branch.pos.x,
			"pos_y" : branch.pos.y,
			"branch_type" : branch.branch_type,
			"leaves" : branch.leaves
		}
		var branch_name = str("branch",branch_num)
		save_dictionary.set(branch_name,JSON.stringify(branch_dictionary))
		branch_num = branch_num + 1
	return save_dictionary

func load_from_dictionary(load_dict : Dictionary):
	var branch_num = 0
	var branch_dictionary_string = load_dict.get(str("branch",branch_num))
	while(branch_dictionary_string != null):
		load_branch_from_dictionary_string(branch_dictionary_string)
		branch_num = branch_num + 1
		branch_dictionary_string = load_dict.get(str("branch",branch_num))

func load_branch_from_dictionary_string(dictionary_string : String):
	var dictionary : Dictionary = JSON.parse_string(dictionary_string)
	var pos_x = dictionary.get("pos_x")
	var pos_y = dictionary.get("pos_y")
	var packed_scene = load(get_packedscene_path())
	var instance : Plant_Tree = packed_scene.instantiate()
	var branch_type = dictionary.get("branch_type")
	var leaves = dictionary.get("leaves")
	instance.set_is_load_branch()
	if(leaves != ""):
		instance.set_load_leaves(leaves)
	var grid_sandbox = get_tree().get_first_node_in_group("grid_sandbox")
	grid_sandbox.add_child(instance)
	instance.match_branch_code(branch_type)
	instance.global_position = Vector2(pos_x,pos_y)
	var grid_base : Grid_Base = get_tree().get_first_node_in_group("grid_base")
	grid_base.update()

func grow_branches():
	var grow_points : Array[String] = []
	for point in branch_points:
		if(!used_branch_points.has(point)):
			grow_points.append(point)
	for point in grow_points:
		var new_branch : Plant_Tree = branch.instantiate()
		new_branch.set_is_branch(distance_from_root,self,trunk_ref)
		get_parent().add_child(new_branch)
		if(point == "left"):
			new_branch.global_position = global_position + Vector2(-16,0)
		elif(point == "right"):
			new_branch.global_position = global_position + Vector2(16,0)
		elif(point == "up"):
			new_branch.global_position = global_position + Vector2(0,-16)
		new_branch.get_branch(root_point_from_branch(point))
		branches.append(new_branch)
		used_branch_points.append(point)
