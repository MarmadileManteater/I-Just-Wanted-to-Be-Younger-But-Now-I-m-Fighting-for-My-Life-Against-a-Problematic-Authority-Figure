extends Node2D

class_name BossFeet

var leftie: AnimatedStaticBody2D
var rightie: StaticBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	leftie = find_child("Leftie")
	rightie = find_child("Rightie")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
