extends AnimationPlayer

class_name AnimationPlayerExtended

var last_animation: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func play_with_memory(animation_name: StringName = &"", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false) -> void:
	last_animation = animation_name
	play(animation_name, custom_blend, custom_speed, from_end)
