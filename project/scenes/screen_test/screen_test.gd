extends Node2D

var boss_feet: BossFeet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss_feet = find_child("BossFeet")
	var animation_player: AnimationPlayer = boss_feet.leftie.animation_player
	animation_player.play("")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
