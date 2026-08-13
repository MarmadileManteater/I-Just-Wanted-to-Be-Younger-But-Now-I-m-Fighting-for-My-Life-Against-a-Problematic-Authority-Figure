extends Node2D

signal next_screen

var hearts: HealthDisplay
var willow: Willow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hearts = find_child("HealthDisplay")
	willow = find_child("Willow")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spikes_damage(damage: int) -> void:
	if not willow.invulnerable:
		hearts.health -= damage
		if hearts.health <= 0:
			willow.die("disintegrate")
		else:
			willow.flash()
		willow.bounce()

func _next_screen(body: Node2D) -> void:
	if body.name == willow.name:
		var info: SceneInfo = SceneInfo.new()
		info.name = "boss_1_screen_1"
		info.health = hearts.health
		info.next_scene = "boss_1_screen_2"
		emit_signal("next_screen", info)
