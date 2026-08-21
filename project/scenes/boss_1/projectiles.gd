extends Node2D

class_name TextProjectiles

signal damage
signal projectile_destroyed
signal projectile_moving

var projectiles: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	projectiles = find_children("Projectile*")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire(target: Node2D) -> void:
	var projectile: TextProjectile = projectiles.pick_random()
	var duplicate = projectile.duplicate()
	projectile.flash_player.play("Default")
	duplicate.damage.connect(
		func ():
			emit_signal("damage")
			emit_signal("projectile_destroyed")
	)
	duplicate.destroy.connect(
		func():
			emit_signal("projectile_destroyed")
	)
	duplicate.moving.connect(
		func ():
			emit_signal("projectile_moving")
	)
	var parent = Node2D.new()
	parent.add_child(duplicate)
	get_parent().add_child(parent)
	duplicate.visible = true
	duplicate.fire(target)
