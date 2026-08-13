extends Node2D

class_name HealthDisplay

@export var health: int = 3

var heart1: AnimatedSprite2D
var heart2: AnimatedSprite2D
var heart3: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	heart1 = find_child("Heart1")
	heart2 = find_child("Heart2")
	heart3 = find_child("Heart3")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health >= 3:
		heart3.animation = "full"
	else:
		heart3.animation = "empty"
		
	if health >= 2:
		heart2.animation = "full"
	else:
		heart2.animation = "empty"
	
	if health >= 1:
		heart1.animation = "full"
	else:
		heart1.animation = "empty"
