extends Node2D

class_name GameOverScreen

var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player = find_child("AnimationPlayer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
