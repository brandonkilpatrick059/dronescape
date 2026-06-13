extends Parallax2D

@onready var sky_gradient : Sprite2D = $sky_gradient
@onready var ground_gradient : Sprite2D = $ground_gradient
@onready var starfield : Sprite2D = $starfield
@onready var planet : Sprite2D = $planet
@onready var mountains : Sprite2D = $mountains

var interpolation_gradient = Gradient.new()
var ground_interpolation_gradient = Gradient.new()
var starfield_interpolation_gradient = Gradient.new()
var planet_interpolation_gradient = Gradient.new()

var hour_length_seconds : float = 10.0
var timer_clock := Timer.new()

var clock = 17

var colors := {
	0.0:      Color(0.314, 0.322, 0.467), #12:00am
	0.041666: Color(0.314, 0.322, 0.467), #1:00
	0.083332: Color(0.314, 0.322, 0.467), #2
	0.124998: Color(0.314, 0.322, 0.467), #3
	0.166664: Color(0.314, 0.322, 0.467), #4
	0.20833:  Color(0.314, 0.322, 0.467), #5
	0.249996: Color(0.514, 0.522, 0.667), #6
	0.291662: Color(0.871, 0.729, 0.847), #7
	0.333328: Color(0.961, 0.863, 0.933), #8
	0.374994: Color(1, 0.937, 0.98), #9
	0.41666:  Color(1, 1, 1), #10
	0.458326: Color(1, 1, 1), #11
	0.499992: Color(1, 1, 1), #12:00pm
	0.541658: Color(1, 1, 1), #1:00pm
	0.583324: Color(1, 1, 1), #2
	0.62499:  Color(1, 1, 1), #3
	0.666656: Color(1, 1, 1), #4
	0.708322: Color(1, 1, 1), #5
	0.749988: Color(1, 0.937, 0.9), #6
	0.791654: Color(0.961, 0.863, 0.933),#Color(0.573, 0.584, 0.702), #7
	0.83332:  Color(0.871, 0.729, 0.847), #8
	0.874986: Color(0.514, 0.522, 0.667), #9
	0.916652: Color(0.314, 0.322, 0.467), #10
	1.0:      Color(0.314, 0.322, 0.467), #11
}

var ground_colors := {
	0.0:      Color(0.029, 0.16, 0.314), #12:00am
	0.041666: Color(0.029, 0.16, 0.314), #1:00
	0.083332: Color(0.029, 0.16, 0.314), #2
	0.124998: Color(0.029, 0.16, 0.314), #3
	0.166664: Color(0.029, 0.16, 0.314), #4
	0.20833:  Color(0.029, 0.16, 0.314), #5
	0.249996: Color(0.029, 0.16, 0.314), #6
	0.291662: Color(0.129, 0.26, 0.414), #7
	0.333328: Color(0.229, 0.36, 0.514), #8
	0.374994: Color(0.329, 0.46, 0.614), #9
	0.41666:  Color(0.429, 0.66, 0.714), #10
	0.458326: Color(0.429, 0.66, 0.714), #11
	0.499992: Color(0.429, 0.66, 0.714), #12:00pm
	0.541658: Color(0.429, 0.66, 0.714), #1:00pm
	0.583324: Color(0.429, 0.66, 0.714), #2
	0.62499:  Color(0.429, 0.66, 0.714), #3
	0.666656: Color(0.429, 0.66, 0.714), #4
	0.708322: Color(0.429, 0.66, 0.714), #5
	0.749988: Color(0.329, 0.46, 0.614), #6
	0.791654: Color(0.129, 0.26, 0.414),#7
	0.83332:  Color(0.029, 0.16, 0.314), #8
	0.874986: Color(0.029, 0.16, 0.314), #9
	0.916652: Color(0.029, 0.16, 0.314), #10
	1.0:      Color(0.029, 0.16, 0.314), #11
}

var starfield_colors := {
	0.0:      Color(1, 1, 1), #12:00am
	0.041666: Color(1, 1, 1), #1:00
	0.083332: Color(0.8, 0.8, 0.8), #2
	0.124998: Color(0.4, 0.4, 0.4), #3
	0.166664: Color(0.2, 0.2, 0.2), #4
	0.20833:  Color(0.0, 0.0, 0.0), #5
	0.249996: Color(0.0, 0.0, 0.0), #6
	0.291662: Color(0.0, 0.0, 0.0), #7
	0.333328: Color(0.0, 0.0, 0.0), #8
	0.374994: Color(0.0, 0.0, 0.0), #9
	0.41666:  Color(0.0, 0.0, 0.0), #10
	0.458326: Color(0.0, 0.0, 0.0), #11
	0.499992: Color(0.0, 0.0, 0.0), #12:00pm
	0.541658: Color(0.0, 0.0, 0.0), #1:00pm
	0.583324: Color(0.0, 0.0, 0.0), #2
	0.62499:  Color(0.0, 0.0, 0.0), #3
	0.666656: Color(0.0, 0.0, 0.0), #4
	0.708322: Color(0.0, 0.0, 0.0), #5
	0.749988: Color(0.0, 0.0, 0.0), #6
	0.791654: Color(0.0, 0.0, 0.0),#7
	0.83332:  Color(0.0, 0.0, 0.0), #8
	0.874986: Color(0.2, 0.2, 0.2), #9
	0.916652: Color(0.4, 0.4, 0.4), #10
	1.0:      Color(0.8, 0.8, 0.8), #11
}

var planet_colors := {
	0.0:      Color(1, 1, 1, 1), #12:00am
	0.041666: Color(1, 1, 1, 1), #1:00
	0.083332: Color(1, 1, 1, 1), #2
	0.124998: Color(1, 1, 1, 1), #3
	0.166664: Color(1, 1, 1, 1), #4
	0.20833:  Color(1, 1, 1, 0.4), #5
	0.249996: Color(1, 1, 1, 0.2), #6
	0.291662: Color(1, 1, 1, 0.2), #7
	0.333328: Color(1, 1, 1, 0.1), #8
	0.374994: Color(1, 1, 1, 0.1), #9
	0.41666:  Color(1, 1, 1, 0.1), #10
	0.458326: Color(1, 1, 1, 0.1), #11
	0.499992: Color(1, 1, 1, 0.1), #12:00pm
	0.541658: Color(1, 1, 1, 0.1), #1:00pm
	0.583324: Color(1, 1, 1, 0.1), #2
	0.62499:  Color(1, 1, 1, 0.2), #3
	0.666656: Color(1, 1, 1, 0.4), #4
	0.708322: Color(1, 1, 1, 1), #5
	0.749988: Color(1, 1, 1, 1), #6
	0.791654: Color(1, 1, 1, 1),#7
	0.83332:  Color(1, 1, 1, 1), #8
	0.874986: Color(1, 1, 1, 1), #9
	0.916652: Color(1, 1, 1, 1), #10
	1.0:      Color(1, 1, 1, 1), #11
}

func get_time_as_ratio_of_full_day() -> float:
	var ratio = 0.0
	ratio = (clock+1.0)/24.0
	ratio += ((hour_length_seconds - timer_clock.time_left)/hour_length_seconds) * (1.0/24.0)
	return ratio

func advance_clock():
	if(clock != 23):
		clock = clock + 1
	else: if(clock == 23):
		clock = 0

func _ready() -> void:
	timer_clock.one_shot = true
	add_child(timer_clock)
	timer_clock.start(hour_length_seconds)
	interpolation_gradient.offsets = colors.keys()
	interpolation_gradient.colors = colors.values()
	ground_interpolation_gradient.offsets = ground_colors.keys()
	ground_interpolation_gradient.colors = ground_colors.values()
	starfield_interpolation_gradient.offsets = starfield_colors.keys()
	starfield_interpolation_gradient.colors = starfield_colors.values()
	planet_interpolation_gradient.offsets = planet_colors.keys()
	planet_interpolation_gradient.colors = planet_colors.values()

func _physics_process(delta: float) -> void:
	if(timer_clock.is_stopped()):
		advance_clock()
		timer_clock.start(hour_length_seconds)
	var day_ratio = get_time_as_ratio_of_full_day()
	sky_gradient.modulate = interpolation_gradient.sample(day_ratio)
	var ground_color : Color = ground_interpolation_gradient.sample(day_ratio)
	ground_gradient.modulate = ground_color
	mountains.modulate = ground_color
	starfield.modulate = starfield_interpolation_gradient.sample(day_ratio)
	planet.modulate = planet_interpolation_gradient.sample(day_ratio)
