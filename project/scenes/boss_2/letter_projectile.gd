extends Node2D

class_name LetterProjectile

@export var speed: float = 10
@export var direction: Vector2 = Vector2(0, 0)
@export var character_name = "Willow"

signal collide
signal destroy

const group_1: Array = ["B", "D", "E", "F", "P", "R", "Y"]
const group_2: Array = ["A", "C", "G", "H", "I", "J", "K", "L", "M", "N", "O", "R", "S", "T", "U", "V", "W", "X", "Z"]

const groups: Array = [group_1, group_2]

var group_number: int = 0

var letter: AnimatedSprite2D
var on_screen_notifier: VisibleOnScreenNotifier2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	letter = find_child("Letter")
	on_screen_notifier = find_child("VisibleOnScreenNotifier2D")

func set_letter(given: String) -> void:
	var character = given[0].to_upper()
	letter.play(character)
	var i = 1
	for group in groups:
		if character in group:
			group_number = i
		i += 1

func _process(delta: float) -> void:
	position += direction * speed
	if not on_screen_notifier.is_on_screen():
		emit_signal("destroy")

func collide_with_body(willow: Willow):
	emit_signal("collide")

func _on_size_1_body_entered(body: Node2D) -> void:
	if group_number == 1:
		if body.name == character_name:
			collide_with_body(body)

func _on_size_2_body_entered(body: Node2D) -> void:
	if group_number == 2:
		if body.name == character_name:
			collide_with_body(body)
