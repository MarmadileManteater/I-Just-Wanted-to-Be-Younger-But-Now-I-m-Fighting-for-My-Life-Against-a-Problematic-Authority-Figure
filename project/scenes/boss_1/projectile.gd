extends Area2D

class_name TextProjectile

signal damage
signal moving

@export var speed: float = 1
@export var timeout: float = 15

var animation_player: AnimationPlayer

var selected_target: Node2D = null
var is_moving: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player = get_child(get_child_count() - 1)

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
			get_parent().remove_child(self)
			self.queue_free()
	)
	timer.start(timeout)

func collide(body: Node2D):
	if body == selected_target:
		if is_moving:
			call_deferred("emit_damage")

func emit_damage():
	get_parent().remove_child(self)
	emit_signal("damage")
	self.queue_free()	
