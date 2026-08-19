extends Area2D

var hurt_animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurt_animation_player = get_parent().find_child("AnimationPlayer")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_zap_projectile_collide() -> bool:
	hurt_animation_player.play("Hurt")
	return true
