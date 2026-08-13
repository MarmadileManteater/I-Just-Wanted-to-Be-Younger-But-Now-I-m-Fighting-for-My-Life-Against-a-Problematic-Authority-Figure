extends Node2D

var boss_feet: BossFeet
var willow: Willow
var dolly: Dolly
var hearts: HealthDisplay

func _ready() -> void:
	boss_feet = find_child("BossFeet")
	willow = find_child("Willow")
	dolly = find_child("Dolly")
	hearts = dolly.find_child("HealthDisplay")
	
	dolly.lock(willow)
	
	boss_feet.leftie.connect("crush", _on_crush)
	boss_feet.rightie.connect("crush", _on_crush)
	boss_feet.animation_player.play("Stomp")

func _on_crush():
	hearts.health = 0
	willow.die("crushed")
