extends CharacterBody2D

class_name Willow

const SPEED = 450.0
const RUNNING_MULTIPLIER = 1.35
const JUMP_VELOCITY = -600.0

var is_running: bool = false
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

func _input(event: InputEvent) -> void:
	if event.is_action("ui_shift"):
		is_running = event.is_pressed()

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
		if is_running:
			velocity.x *= RUNNING_MULTIPLIER
		sprite.flip_h = direction > 0
		if is_on_floor():
			if sprite.animation != "crushed":# TODO do this right
				sprite.change_animation("walk")
				if is_running:
					sprite.speed_scale = RUNNING_MULTIPLIER
				else:
					sprite.speed_scale = 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			if sprite.animation != "crushed":# TODO do this right
				sprite.change_animation("default")

	if not is_on_floor():
		if sprite.animation != "crushed":# TODO do this right
			sprite.change_animation("jump")

	move_and_slide()
