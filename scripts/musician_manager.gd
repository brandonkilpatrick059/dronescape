class_name Musician_Manager extends Node2D

class musician_group:
	var group_x : float = 0.0
	func get_group_x():
		return group_x
	func set_group_x(new_x : float):
		group_x = new_x
	var grouped_musicians : Array[Node2D] = []
	func append_musician(append : Node2D):
		grouped_musicians.append(append)
	func get_grouped_musicians() -> Array[Node2D]:
		return grouped_musicians
	func finished_playing() -> bool:
		var finished = true
		for musician in grouped_musicians:
			finished = finished && musician.finished_playing()
		return finished
	func play_music():
		for musician in grouped_musicians:
			musician.play_music()

var musicians : Array[musician_group] = []
var simultaneous_musicians : Array[Node2D] = []

var index = 0

func update_musicians():
	var old_num_musicians = musicians.size()
	musicians = []
	var all_musicians = get_tree().get_nodes_in_group("musician")
	#sorts the musicians from left to right
	#which is the order in which they are played
	#musicians sharing an x-coordinate will be played simultaneously
	while(all_musicians.size() > 0):
		var min_x = all_musicians[0].global_position.x
		var leftmost_musician : Node2D = all_musicians[0]
		for musician in all_musicians:
			var musician_x = musician.global_position.x
			if(musician_x < min_x):
				leftmost_musician = musician
		append_to_musicians(leftmost_musician)
		all_musicians.erase(leftmost_musician)

	if(old_num_musicians > musicians.size()):
		index = musicians.size() - 1

func append_to_musicians(node : Node2D):
	var node_x = node.global_position.x
	for musician_group : musician_group in musicians:
		if(musician_group.get_group_x() == node_x):
			musician_group.append_musician(node)
			return
	#no existing group with node_x
	var new_group : musician_group = musician_group.new()
	new_group.set_group_x(node_x)
	new_group.append_musician(node)
	musicians.append(new_group)

func advance_index():
	index = index + 1
	if(index >= musicians.size()):
		index = 0
	if(musicians.size() > 0 && index < musicians.size()):
		if(musicians[index].finished_playing()):
			musicians[index].play_music()

func _physics_process(delta: float) -> void:
	update_musicians()
	if(musicians.size() > 0 && index < musicians.size()):
		if(musicians[index] != null && musicians[index].finished_playing()):
			advance_index()
