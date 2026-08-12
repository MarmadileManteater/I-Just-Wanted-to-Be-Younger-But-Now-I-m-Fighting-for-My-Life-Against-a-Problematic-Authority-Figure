extends Node2D

class_name BossFeet

@export var character_name: String = "Willow"

var leftie: CrushingFoot
var rightie: StaticBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	leftie = find_child("Leftie")
	leftie.character_name = character_name
	rightie = find_child("Rightie")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
