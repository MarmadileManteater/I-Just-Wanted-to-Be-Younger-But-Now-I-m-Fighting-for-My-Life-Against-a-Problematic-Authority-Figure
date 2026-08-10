extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var sprite: AnimatedSprite2D

func set_animation(name: String) -> void:
	var frame = sprite.frame
	var progress = sprite.frame_progress
	sprite.animation = name
	sprite.set_frame_and_progress(frame, progress)

func _enter_tree() -> void:
	sprite = find_child("Sprite")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.animation = "walk"
		sprite.flip_h = direction > 0
	else:
		sprite.animation = "default"
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_on_floor():
		set_animation("jump")

	move_and_slide()
