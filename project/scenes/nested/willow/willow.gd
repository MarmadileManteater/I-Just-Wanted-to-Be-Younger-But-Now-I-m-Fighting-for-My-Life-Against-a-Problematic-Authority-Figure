extends CharacterBody2D

class_name Willow

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity_enabled: bool = true
var sprite: AnimatedSpriteExtension
var shape: CollisionShape2D

func change_animation(name: String) -> void:
	sprite.change_animation(name)
	
func play(name: String) -> void:
	sprite.play(name)

func _ready() -> void:
	sprite = find_child("Sprite")
	shape = find_child("Shape")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and gravity_enabled:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction > 0
		if is_on_floor():
			if sprite.animation != "crushed":# TODO do this right
				sprite.change_animation("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			if sprite.animation != "crushed":# TODO do this right
				sprite.change_animation("default")

	if not is_on_floor():
		if sprite.animation != "crushed":# TODO do this right
			sprite.change_animation("jump")

	move_and_slide()
