extends Node2D

@export var seconds_to_fallthrough: float = 2
@export var seconds_to_restore: float = 2
@export var character_name = "Willow"
@export var character_height = 300
@export var fallthrough_inevitable = true
@export var type: int = 1

var fall_through_timer: Timer
var restore_timer: Timer

var static_body: StaticBody2D
var collision_shape: CollisionShape2D
var animated_sprite: AnimatedSprite2D

var willow: Willow

func play_animation(name: String) -> void:
	var type_string = ""
	if type != 1:
		type_string = "_%d" % type
	animated_sprite.play(name + type_string)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	static_body = find_child("StaticBody2D")
	collision_shape = static_body.find_child("CollisionShape2D")
	animated_sprite = find_child("AnimatedSprite2D", true)
	play_animation("default")

func _process(delta: float) -> void:
	if willow != null:
		var collision: KinematicCollision2D = willow.move_and_collide(Vector2(0,0.2), true)
		if collision != null:
			if collision.get_collider() == static_body: 
				play_animation("shaking")
				fall_through_timer = Timer.new()
				fall_through_timer.connect("timeout", fall_through)
				fall_through_timer.one_shot = true
				add_child(fall_through_timer)
				fall_through_timer.start(seconds_to_fallthrough)
				willow = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == character_name:
		if animated_sprite.animation != "fall":
			willow = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == character_name:
		willow = null
		if fall_through_timer != null:
			if fallthrough_inevitable:
				return
			fall_through_timer.disconnect("timeout", fall_through)
			remove_child(fall_through_timer)
			fall_through_timer = null
			play_animation("default")

func fall_through() -> void:
	willow = null
	fall_through_timer.disconnect("timeout", fall_through)
	remove_child(fall_through_timer)
	fall_through_timer = null
	play_animation("fall")
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
	play_animation("restore")
	collision_shape.disabled = false
