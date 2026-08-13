extends Camera2D

class_name Dolly

var focused_node: Node2D = null
var position_offset: Vector2

func lock(node: Node2D):
	focused_node = node
	position_offset = position - node.position
	
func unlock():
	focused_node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if focused_node != null:
		position.x = focused_node.position.x + position_offset.x
