extends StaticBody2D

class_name AnimatedStaticBody2D

var animation_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player = find_child("AnimationPlayer")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
