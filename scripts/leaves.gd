class_name Leaves extends Node2D

var sprites : Array[AnimatedSprite2D] = []
@onready var wind_activation_area : Area2D = $Area2D

var timer := Timer.new()

var activation_level : float = 0.0 #is 0.0 to 1.0
var wind_affect_x_velocity : float = 0.0
var speed_set_scale : float = 0.0
var sensitivity = 0.8
var friction = 0.2
var wind_effect_activation_level = 0.05 

var speed_scale_mults: Array[float] = []

var animate_direction : String = ""

func _ready() -> void:
	timer.one_shot = true
	add_child(timer)
	var leaves = $leaves.get_children()
	var add = 0.0
	for leaf in leaves:
		var gen = randf_range(0.5,1.0)
		if(gen < 0.5):
			add = add + 0.01
		gen = gen + add
		if(gen > 1.0):
			gen = 1.0
		speed_scale_mults.append(gen)
	set_speed_scales(0.0)
	update_wind_animation()

func update_wind_animation():
	if(activation_level > wind_effect_activation_level):
		var new_animate_direction = ""
		if(wind_affect_x_velocity > 0.0):
			new_animate_direction = "right"
		else:
			new_animate_direction = "left"
		if(new_animate_direction != animate_direction):
			animate_direction = new_animate_direction
			var animation = str(animate_direction)
			play_animation(animation)
	
	speed_set_scale = activation_level
	update_speed_scales()

func play_animation(name: String):
	var leaves = $leaves.get_children()
	for leaf in leaves:
		leaf.play(name)
 
func set_speed_scales(new_scale : float):
	var leaves = $leaves.get_children()
	for leaf in leaves:
		leaf.speed_scale = new_scale

func update_speed_scales():
	var leaves = $leaves.get_children()
	var index = 0
	for leaf : AnimatedSprite2D in leaves:
		#if(speed_set_scale < 0.0): 
			#leaf.speed_scale = 0.0 
			#leaf.frame = 0 
		if(leaf.speed_scale <= 0.35 &&
		speed_set_scale <= 0.2 &&
		leaf.frame == 0):
			leaf.speed_scale = 0.0
		else:
			var mult = speed_scale_mults[index]
			if(leaf.speed_scale < speed_set_scale * mult):
				leaf.speed_scale = leaf.speed_scale + randf_range(0.005,0.03)
			elif(leaf.speed_scale > speed_set_scale * mult):
				leaf.speed_scale = leaf.speed_scale - 0.001
		index = index + 1

func update_activation_level():
	var winds = wind_activation_area.get_overlapping_bodies()
	var highest_energy : float = 0.0
	var new_wind_affect_x_velocity = 0.0
	for wind : Wind_Particle in winds:
		if(wind.get_energy() > highest_energy):
			highest_energy = wind.get_energy()
			new_wind_affect_x_velocity = wind.get_velocity_x()
	var new_activation = sensitivity * highest_energy
	if(new_activation > activation_level):
		activation_level = new_activation 
		wind_affect_x_velocity = new_wind_affect_x_velocity
	activation_level = activation_level - friction
	if(activation_level > 1.0):
		activation_level = 1.0
	elif(activation_level < 0.0):
		activation_level = 0.0

func _physics_process(delta: float) -> void:
	update_activation_level()
	update_wind_animation()
