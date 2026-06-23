class_name Water_Fall extends Grid_Entity

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var top_sprite : AnimatedSprite2D = $top
@onready var continued_falls : PackedScene = preload("res://entities/water/water_fall.tscn")
@onready var solid_detector : Area2D = $solid_detector
@onready var water_detector : Area2D = $water_detector
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
var timer := Timer.new()
var criteria_lock_timer := Timer.new()

var mist = preload("res://effects/mist.tscn")

var falls_ref = null
var fall_created = false
var is_top_of_falls = true

func _ready() -> void:
	grid_entity_init()
	audio_player.bus = "effects"
	timer.one_shot = true
	criteria_lock_timer.one_shot = true
	add_child(criteria_lock_timer)
	add_child(timer)
	timer.start(0.25)
	if(is_top_of_falls):
		sprite.visible = false
		top_sprite.visible = true
		top_sprite.play("top")
		add_to_group("water_fall")
	else:
		sprite.visible = true
		top_sprite.visible = false
		sprite.play("falls")
	criteria_lock_timer.start(0.1)

func set_animation_frame(frame : int, progress : float):
	sprite.set_frame_and_progress(frame,progress)
	

func is_not_top_of_falls():
	is_top_of_falls = false

func solid_below() -> bool:
	var bodies = solid_detector.get_overlapping_bodies()
	if(bodies.size() > 0):
		return true
	return false

func going_offscreen() -> bool:
	var camera = get_tree().get_first_node_in_group("camera")
	if(camera.global_position.distance_to(global_position) > 300):
		return true
	return false

func get_current_frame() -> int:
	if(is_top_of_falls):
		return top_sprite.frame
	else:
		return sprite.frame

func get_current_progress() -> float:
	if(is_top_of_falls):
		return top_sprite.frame_progress
	else:
		return sprite.frame_progress

func _physics_process(delta: float) -> void:
	if(is_top_of_falls && criteria_lock_timer.is_stopped()):
		queue_free_on_failed_placement_criteria()
	if(!is_top_of_falls):
		var bodies = water_detector.get_overlapping_bodies()
		var found_water = false
		for body in bodies:
			if (body.get_parent().is_in_group("water")):
				found_water = true
		if(!found_water):
			queue_free()
		
	if(timer.is_stopped() && falls_ref == null):
		if(fall_created):
			fall_created = false
			timer.start(0.25)
		elif(!solid_below() && !going_offscreen()):
			if(audio_player.playing):
				audio_player.stop()
			falls_ref = continued_falls.instantiate()
			falls_ref.is_not_top_of_falls()
			get_parent().add_child(falls_ref)
			falls_ref.set_animation_frame(get_current_frame(),get_current_progress())
			falls_ref.global_position = global_position + Vector2(0,16)
			fall_created = true
		elif(solid_below()):
			if(!audio_player.playing):
				audio_player.play()
			var mist1 = mist.instantiate()
			var mist2 = mist.instantiate()
			var mist3 = mist.instantiate()
			var mist4 = mist.instantiate()
			get_parent().add_child(mist1)
			mist1.global_position = global_position + Vector2(-4,8)
			get_parent().add_child(mist2)
			mist2.global_position = global_position + Vector2(-12,8)
			get_parent().add_child(mist3)
			mist3.global_position = global_position + Vector2(4,8)
			get_parent().add_child(mist4)
			mist4.global_position = global_position + Vector2(8,8)
			timer.start(0.5)
			
			
