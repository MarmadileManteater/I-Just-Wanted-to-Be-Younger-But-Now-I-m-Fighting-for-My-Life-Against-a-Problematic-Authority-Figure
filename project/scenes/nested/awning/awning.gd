extends Node2D

@export var seconds_to_fallthrough = 2
@export var seconds_to_restore = 2
@export var character_name = "Willow"

var fall_through_timer: Timer
var restore_timer: Timer

var static_body: StaticBody2D
var collision_shape: CollisionShape2D
var animated_sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	static_body = find_child("StaticBody2D")
	collision_shape = static_body.find_child("CollisionShape2D")
	animated_sprite = find_child("AnimatedSprite2D", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	# TODO make this based on detected collision with static body instead of area 2d
	if body.name == character_name:
		if animated_sprite.animation != "fall":
			animated_sprite.play("shaking")
			fall_through_timer = Timer.new()
			fall_through_timer.connect("timeout", fall_through)
			fall_through_timer.one_shot = true
			add_child(fall_through_timer)
			fall_through_timer.start(seconds_to_fallthrough)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == character_name:
		if fall_through_timer != null:
			fall_through_timer.disconnect("timeout", fall_through)
			remove_child(fall_through_timer)
			fall_through_timer = null
			animated_sprite.play("default")

func fall_through() -> void:
	fall_through_timer.disconnect("timeout", fall_through)
	remove_child(fall_through_timer)
	fall_through_timer = null
	animated_sprite.play("fall")
	collision_shape.disabled = true
	restore_timer = Timer.new()
	restore_timer.connect("timeout", restore)
	restore_timer.one_shot = true
	add_child(restore_timer)
	restore_timer.start(seconds_to_restore)

func restore() -> void:
	restore_timer.disconnect("timeout", restore)
	remove_child(restore_timer)
	restore_timer = null
	animated_sprite.play("restore")
	collision_shape.disabled = false
