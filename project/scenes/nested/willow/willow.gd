extends CharacterBody2D

class_name Willow

const SPEED = 450.0
const RUNNING_MULTIPLIER = 1.35
const JUMP_VELOCITY = -600.0

enum DIRECTION { LEFT, RIGHT }
@export var starting_direction: DIRECTION
@export var invulnerable: bool = false

var is_running: bool = false
var is_dying: bool = false
var gravity_enabled: bool = true
var sprite: AnimatedSpriteExtension
var shape: CollisionShape2D
var animation_player: AnimationPlayer
var wand_animation_player: AnimationPlayer

func change_animation(name: String) -> void:
	sprite.change_animation(name)
	
func play(name: String) -> void:
	sprite.play(name)
	
func bounce(multiplier: float = 1) -> void:
	velocity.y = JUMP_VELOCITY * multiplier

func flash() -> void:
	animation_player.play("Flash")
	
func die(method: String = "") -> void:
	is_dying = true
	shape.disabled = true
	gravity_enabled = false
	velocity = Vector2(0, 0)
	if method != "":
		play(method)
		sprite.connect("animation_finished", hide)
	else:
		hide()

func _ready() -> void:
	sprite = find_child("Sprite")
	shape = find_child("Shape")
	animation_player = find_child("AnimationPlayer")
	wand_animation_player = find_child("WandAnimationPlayer", true)
	if starting_direction == DIRECTION.RIGHT:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1

func _input(event: InputEvent) -> void:
	if event.is_action("ui_shift"):
		is_running = event.is_pressed()

func _physics_process(delta: float) -> void:
	if is_dying:
		return
	# Add the gravity.
	if not is_on_floor() and gravity_enabled:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("ui_up"):
		wand_animation_player.play("point_up")
	if Input.is_action_just_released("ui_up"):
		wand_animation_player.play("point")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if is_running:
			velocity.x *= RUNNING_MULTIPLIER
		if direction > 0:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1
		if is_on_floor():
			sprite.change_animation("walk")
			if is_running:
				sprite.speed_scale = RUNNING_MULTIPLIER
			else:
				sprite.speed_scale = 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			sprite.change_animation("default")

	if not is_on_floor():
		sprite.change_animation("jump")

	move_and_slide()
