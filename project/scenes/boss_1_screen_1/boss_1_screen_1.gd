extends DefaultScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func _on_spikes_damage(damage: int) -> void:
	if not willow.invulnerable:
		hearts.health -= damage
		if hearts.health <= 0:
			willow.die("disintegrate")
		else:
			willow.flash()
		willow.bounce()
