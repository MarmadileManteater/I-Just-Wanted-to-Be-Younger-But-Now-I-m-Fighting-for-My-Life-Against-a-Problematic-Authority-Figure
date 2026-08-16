extends Area2D

class_name NextScreenArea

signal next_scene

enum Direction { X, Y }

@export var scene: String
@export var health: int = 3
@export var character_name: String  = "Willow"
@export var direction: Direction = Direction.Y 

func _ready() -> void:
	if direction == Direction.Y:
		remove_child(find_child("Wide"))
	if direction == Direction.X:
		remove_child(find_child("Tall"))

func _on_body_entered(body: Node2D) -> void:
	if body.name == character_name:
		var info = SceneInfo.new()
		info.health = health
		info.next_scene = scene
		emit_signal("next_scene", info)
