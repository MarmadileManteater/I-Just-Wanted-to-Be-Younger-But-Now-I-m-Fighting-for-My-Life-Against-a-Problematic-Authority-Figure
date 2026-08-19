extends StaticBody2D

signal crushed

@export var about_to_crush = false
@export var character_name = "Willow"
var crush_area: Area2D
var crushed_body: Willow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crush_area = find_child("CrushArea")
	crush_area.connect("body_entered", _on_body_entered_crush_area)
	crush_area.connect("body_exited", _on_body_exited_crush_area)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if about_to_crush:
		if crushed_body != null:
			emit_signal("crushed", global_position)

func _on_body_entered_crush_area(body: Node2D):
	if body.name == character_name:
		crushed_body = body

func _on_body_exited_crush_area(body: Node2D):
	if body.name == character_name:
		crushed_body = null

func _on_zap_projectile_collide() -> bool:
	return true
