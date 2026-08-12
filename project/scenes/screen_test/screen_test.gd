extends Node2D

var boss_feet: BossFeet
var willow: Willow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss_feet = find_child("BossFeet")
	willow = find_child("Willow")
	var animation_player: AnimationPlayer = boss_feet.leftie.animation_player
	boss_feet.leftie.connect("crush", _on_crush)
	animation_player.play("Stomp")
	pass # Replace with function body.

func _on_crush():
	remove_child(willow)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
