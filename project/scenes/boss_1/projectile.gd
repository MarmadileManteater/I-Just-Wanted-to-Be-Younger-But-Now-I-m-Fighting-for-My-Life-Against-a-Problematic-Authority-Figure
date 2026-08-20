extends Area2D

class_name TextProjectile

signal damage
signal moving
signal destroy

@export var health: float = 10

@export var speed: float = 1
@export var timeout: float = 15

var animation_player: AnimationPlayer
var flash_player: AnimationPlayer

var selected_target: Node2D = null
var is_moving: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flash_player = get_child(get_child_count() - 2)
	animation_player = get_child(get_child_count() - 1)
	flash_player.play("Default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if selected_target != null:
		if is_moving:
			if selected_target.global_position.x < global_position.x:
				position.x -= speed
			if selected_target.global_position.x > global_position.x:
				position.x += speed
			if selected_target.global_position.y < global_position.y:
				position.y -= speed
			if selected_target.global_position.y > global_position.y:
				position.y += speed

func fire(target: Node2D) -> void:
	selected_target = target
	animation_player.play("Typewriter")
	animation_player.animation_finished.connect(move)
	body_entered.connect(collide)

func move(_animation_name) -> void:
	z_index = 10
	animation_player.play("Bounce")
	is_moving = true
	emit_signal("moving")
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(
		func ():
			remove_child(timer)
			timer.queue_free()
			destroy_self()
	)
	timer.start(timeout)

func collide(body: Node2D):
	if body == selected_target:
		if is_moving:
			call_deferred("emit_damage")
			destroy_self()

func emit_damage():
	emit_signal("damage")

func emit_destroy():
	emit_signal("destroy")

func _on_zap_projectile_collide() -> bool:
	if is_moving:
		health -= 1
		flash_player.play("Flash")
		if health <= 0:
			destroy_self()
		return true
	else:
		return false
		
func destroy_self() -> void:
	var parent = get_parent()
	parent.get_parent().remove_child(parent)
	parent.queue_free()
	emit_signal("destroy")
