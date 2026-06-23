extends Grid_Entity

@onready var spine : CollisionPolygon2D = $spine/CollisionPolygon2D
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var spine_extended : bool = false
var spine_extending : bool = false
var spine_retracting : bool = false

var timer := Timer.new()
var criteria_lock_timer := Timer.new()

func _ready() -> void:
	grid_entity_init()
	timer.one_shot = true
	criteria_lock_timer.one_shot = true
	add_child(timer)
	add_child(criteria_lock_timer)
	animated_sprite.play("retracted")
	spine.disabled = true
	criteria_lock_timer.start(0.1)

func _physics_process(delta: float) -> void:
	if(criteria_lock_timer.is_stopped()):
		queue_free_on_failed_placement_criteria()
	if(!spine_extended && !spine_extending):
		animated_sprite.play("retracted")
		spine.disabled = true
		spine.visible = false
	elif(!spine_extended && spine_extending):
		if(animated_sprite.frame == animated_sprite.sprite_frames.get_frame_count("extend")-1):
			spine_extended = true
			spine_extending = false
	elif(spine_extended && !spine_retracting):
		animated_sprite.play("extended")
		spine.disabled = false
		spine.visible = true
	elif(spine_extended && spine_retracting):
		if(animated_sprite.frame == animated_sprite.sprite_frames.get_frame_count("retract")-1):
			spine_extended = false
			spine_retracting = false
	if(timer.is_stopped()):
		if(spine_extended):
			spine_retracting = true
			animated_sprite.play("retract")
		else:
			spine_extending = true
			animated_sprite.play("extend")
		#timer.start(3.0)
		timer.start(randf_range(5.0,10.0))
