extends Area2D

class_name NextScreenArea

signal next_scene

@export var scene: String
@export var health: int = 3
@export var character_name: String  = "Willow"

func _on_body_entered(body: Node2D) -> void:
	if body.name == character_name:
		var info = SceneInfo.new()
		info.health = health
		info.next_scene = scene
		emit_signal("next_scene", info)
