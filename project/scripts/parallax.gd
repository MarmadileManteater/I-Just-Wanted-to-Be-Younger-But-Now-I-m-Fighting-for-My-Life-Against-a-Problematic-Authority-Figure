extends Node2D

@export var camera: Node2D
@export var distance: float = 0.1
var initial_position: Vector2
var camera_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = position
	camera_position = camera.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var diff = camera_position - camera.position
	
	position += diff * distance
	camera_position = camera.position
