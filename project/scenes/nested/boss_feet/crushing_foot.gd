extends StaticBody2D

class_name CrushingFoot
signal crush

@export var crush_height: float = -246.872

var character_name: String
var collision_area: Area2D
var is_under: bool = false
var crushed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_area = find_child("CollisionArea")
	collision_area.connect("body_entered", _on_body_entered)
	collision_area.connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.name == character_name:
		is_under = true
	
func _on_body_exited(body: Node2D) -> void:
	if body.name == character_name:
		is_under = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y > crush_height:
		if is_under and not crushed:
			emit_signal("crush")
			crushed = true

	pass
