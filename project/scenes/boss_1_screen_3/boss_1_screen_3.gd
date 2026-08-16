extends DefaultScene

var bottom_camera_boundary_part_2: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	bottom_camera_boundary_part_2 = find_child("BottomCameraBoundaryPart2").find_child("Shape")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
