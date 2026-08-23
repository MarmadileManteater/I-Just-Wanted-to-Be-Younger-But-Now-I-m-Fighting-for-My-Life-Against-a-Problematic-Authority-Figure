extends AnimatedSprite2D

class_name AnimatedSpriteExtension

# changes animation without changing frame number or speed
func change_animation(animation_name: String) -> void:
	var f = frame
	var progress = frame_progress
	var speed = speed_scale
	play(animation_name, speed)
	set_frame_and_progress(f, progress)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
