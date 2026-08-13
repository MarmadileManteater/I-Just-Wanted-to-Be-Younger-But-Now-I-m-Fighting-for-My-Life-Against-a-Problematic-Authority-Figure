extends CharacterBody2D

class_name Dolly

@export var threshold = 100

var locked_node: Node2D

func lock(node: Node2D):
	locked_node = node	

func correct_position(diff: float):
	var abs_diff = abs(diff)
	
	var inside_threshold = (abs_diff < threshold)
	
	var moving_backwards = (diff < 0 and locked_node.velocity.x < diff) or (diff > 0 and locked_node.velocity.x > diff)
	
	var outside_threshold_slightly = not inside_threshold and diff < threshold * 2
	
	if inside_threshold or (outside_threshold_slightly and moving_backwards):
		var speed = locked_node.velocity.x
		if locked_node.position.x < position.x or locked_node.position.x > position.x:
			velocity.x = speed
		else:
			velocity.x = 0
	else:
		velocity.x = 0

func _physics_process(delta: float) -> void:
	if locked_node != null:
		var diff = locked_node.position.x - position.x
		correct_position(diff)
		move_and_slide()
