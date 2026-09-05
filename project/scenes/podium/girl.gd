extends AnimatedSprite2D

class_name Girl

const names = ["Lily", "Eve", "Willow"]

var girl = 1
var points = 0
var animation_player: AnimationPlayer

func get_girl_name() -> String:
	return names[girl - 1]

func set_girl(number: int) -> void:
	if number == 3:
		flip_h = true
	girl = number
	play("girl_%d" % number)
	
func fade_in():
	animation_player.play("FadeIn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player = find_child("AnimationPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
