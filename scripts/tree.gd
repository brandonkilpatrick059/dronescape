class_name Plant_Tree extends Grid_Entity

@export var max_height = 1

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var branch : PackedScene = preload("res://entities/plants/tree_1.tscn")
@onready var leaves_small : PackedScene = preload("res://entities/plants/leaves_1_small.tscn")
@onready var leaves_large : PackedScene = preload("res://entities/plants/leaves_1_large.tscn")
@onready var growth_check_collider : Criteria_Collider = $criteria_collider
var timer := Timer.new()

var min_growth_time : float = 10.0
var max_growth_time : float = 60.0

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
		sprite.play("trunk_ground")
		trunk_ref = self

func set_trunk_ref (ref : Plant_Tree):
	trunk_ref = ref

func set_is_branch(in_distance : int, parent : Plant_Tree, trunk : Plant_Tree):
	distance_from_root = in_distance + 1
	is_trunk = false
	parent_branch = parent
	trunk_ref = trunk

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
	sprite.play("branch_fork_right")
	root_point = "down"
	branch_points = ["up","right"]
	trunk_ref.add_forks()

func branch_fork_inv_from_left():
	sprite.play("branch_fork_inv")
	root_point = "left"
	branch_points = ["up","right"]
	trunk_ref.add_forks()

func branch_fork_inv_from_right():
	sprite.play("branch_fork_inv")
	root_point = "right"
	branch_points = ["up","right"]
	trunk_ref.add_forks()

func branch_fork_left():
	sprite.play("branch_fork_left")
	root_point = "down"
	branch_points = ["up","left"]
	trunk_ref.add_forks()

func branch_fork_up():
	sprite.play("branch_fork_up")
	root_point = "down"
	branch_points = ["right","left"]
	trunk_ref.add_forks()

func branch_bend_left():
	sprite.play("branch_bend_left")
	root_point = "down"
	branch_points = ["left"]

func branch_bend_right():
	sprite.play("branch_bend_right")
	root_point = "down"
	branch_points = ["right"]

func branch_inv_bend_left():
	sprite.play("branch_inv_bend_left")
	root_point = "left"
	branch_points = ["up"]

func branch_inv_bend_right():
	sprite.play("branch_inv_bend_right")
	root_point = "right"
	branch_points = ["up"]

func branch_straight_up():
	sprite.play("branch_straight_up")
	root_point = "down"
	branch_points = ["up"]

func branch_end():
	sprite.play("branch_end")
	root_point = "down"
	branch_points = []
	if(leaves_ref == null):
		if(randf_range(0.0,1.0) < 0.5):
			leaves_ref = leaves_large.instantiate()
			add_child(leaves_ref)
		elif(randf_range(0.0,1.0) < 0.5):
			leaves_ref = leaves_small.instantiate()
			add_child(leaves_ref)

func set_orientation(name : String):
	sprite.play(name)

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

func _physics_process(delta: float) -> void:
	queue_free_on_failed_placement_criteria()
	if(timer.is_stopped() && is_trunk):
		propogate_growth()
		timer.start(growth_wait_secs)
		#if(grass_created):
			#grass_created = false
			#timer.start(randf_range(min_growth_time,max_growth_time))
		#else:
			#tall_grass_ref = tall_grass.instantiate()
			#get_parent().add_child(tall_grass_ref)
			#tall_grass_ref.global_position = global_position + Vector2(0,-16)
			#grass_created = true
