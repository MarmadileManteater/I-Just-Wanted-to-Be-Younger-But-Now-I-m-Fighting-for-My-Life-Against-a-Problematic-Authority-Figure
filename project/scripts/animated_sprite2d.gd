extends AnimatedSprite2D

class_name AnimatedSpriteExtension

# changes animation without changing frame number or speed
func change_animation(name: String) -> void:
	var f = frame
	var progress = frame_progress
	var speed = speed_scale
	play(name, speed)
	set_frame_and_progress(f, progress)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
