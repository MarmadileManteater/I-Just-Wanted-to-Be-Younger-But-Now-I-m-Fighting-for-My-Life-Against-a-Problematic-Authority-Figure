extends Node2D

var boss_feet: BossFeet
var willow: Willow
var dolly: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss_feet = find_child("BossFeet")
	willow = find_child("Willow")
	var animation_player: AnimationPlayer = boss_feet.leftie.animation_player
	var animation_player2: AnimationPlayer = boss_feet.rightie.animation_player
	boss_feet.leftie.connect("crush", _on_crush)
	boss_feet.rightie.connect("crush", _on_crush)
	animation_player.play("Stomp")
	animation_player2.play("Stomp")
	dolly = find_child("Dolly")
	dolly.lock(willow)
	pass # Replace with function body.

func _on_crush():
	# TODO do this right
	willow.shape.disabled = true
	willow.gravity_enabled = false
	willow.velocity = Vector2(0, 0)
	willow.play("crushed")
	pass


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	dolly.unlock()
