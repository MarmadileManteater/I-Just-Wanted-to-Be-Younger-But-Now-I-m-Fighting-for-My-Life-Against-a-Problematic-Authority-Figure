extends CharacterBody2D

class_name Dolly

enum Axis { X = 0, Y = 1 }

@export var threshold = 100
@export var locked_offset: float = 0

var locked_node: Node2D
var locked_axis: Axis

func unlock() -> void:
	locked_node = null

func lock(node: Node2D, axis: Axis = Axis.X):
	locked_node = node
	locked_axis = axis

func get_camera_position() -> float:
	return position[locked_axis]
	
func get_locked_node_position() -> float:
	return locked_node.position[locked_axis] + locked_offset

func correct_position(diff: float):
	var abs_diff = abs(diff)
	
	var inside_threshold = (abs_diff < threshold)
	
	var moving_backwards = (diff < 0 and locked_node.velocity[locked_axis] < diff) or (diff > 0 and locked_node.velocity[locked_axis] > diff)
	
	var outside_threshold_slightly = not inside_threshold and diff < threshold * 2
	
	if inside_threshold or (outside_threshold_slightly and moving_backwards):
		var speed = locked_node.velocity[locked_axis]
		if get_locked_node_position() < get_camera_position() or get_locked_node_position() > get_camera_position():
			velocity[locked_axis] = speed
		else:
			velocity[locked_axis] = 0
	else:
		velocity[locked_axis] = 0

func _physics_process(delta: float) -> void:
	if locked_node != null:
		var diff = get_locked_node_position() - get_camera_position()
		correct_position(diff)
		move_and_slide()
