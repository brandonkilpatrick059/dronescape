class_name Musician_Manager extends Node2D

var musicians : Array[Node2D] = []

var index = 0

func update_musicians():
	var old_num_musicians = musicians.size()
	musicians = []
	var all_musicians = get_tree().get_nodes_in_group("musician")
	#sorts the musicians from left to right
	#which is the order in which they are played
	while(all_musicians.size() > 0):
		var min_x = all_musicians[0].global_position.x
		var leftmost_musician : Node2D = all_musicians[0]
		for musician in all_musicians:
			var musician_x = musician.global_position.x
			if(musician_x < min_x):
				leftmost_musician = musician
		musicians.append(leftmost_musician)
		all_musicians.erase(leftmost_musician)

	if(old_num_musicians > musicians.size()):
		index = musicians.size() - 1

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
