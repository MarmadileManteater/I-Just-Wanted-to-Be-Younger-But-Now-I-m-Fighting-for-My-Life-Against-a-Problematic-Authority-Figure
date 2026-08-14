extends Node2D

var willow: Willow
var dolly: Dolly
var hearts: HealthDisplay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	willow = find_child("Willow")
	dolly = find_child("Dolly")
	hearts = dolly.find_child("HealthDisplay")
	dolly.lock(willow, Dolly.Axis.Y)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
