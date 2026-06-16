class_name Musician extends Grid_Entity

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

static var zero_volume : float = -80
var max_volume : float = -6.0

var criteria_lock_timer := Timer.new()
var update_manager_lock = false

var finished_timer := Timer.new()
@export var finished_after_secs = 0.0

func _ready() -> void:
	grid_entity_init()
	add_to_group("musician")
	initialize_audio()
	animated_sprite.play("default")
	
	#locks criteria checks to prevent
	#queue_freeing during loading
	criteria_lock_timer.one_shot = true
	add_child(criteria_lock_timer)
	criteria_lock_timer.start(1.0)
	
	finished_timer.one_shot = true
	add_child(finished_timer)

func initialize_audio():
	audio_player.volume_db = max_volume

func play_music():
	audio_player.play()
	animated_sprite.play("playing")
	update_manager_lock = false
	finished_timer.start(finished_after_secs)

func finished_playing():
	if(finished_after_secs > 0.0):
		if(finished_timer.is_stopped()):
			return true
		else:
			return false
	else:
		return !audio_player.playing

func _physics_process(delta: float) -> void:
	var finished = audio_player.get_playback_position() >= audio_player.stream.get_length()
	if(!audio_player.playing && !update_manager_lock):
		animated_sprite.play("default")
		audio_player.stop()
	if(criteria_lock_timer.is_stopped()):
		queue_free_on_failed_placement_criteria()
	#debug_input()
	
