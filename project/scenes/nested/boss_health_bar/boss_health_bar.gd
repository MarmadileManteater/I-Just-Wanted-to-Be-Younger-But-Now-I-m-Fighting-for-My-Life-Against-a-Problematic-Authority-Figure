extends Node2D

class_name BossHealthBar

@export var percentage: float = 1.0
@export var color: Color = Color.from_rgba8(254, 108, 108)

var health_polygon: Polygon2D

func set_color(given: Color = color) -> void:
	color = given
	health_polygon.color = color

func set_percentage(given: float = percentage) -> void:
	percentage = given
	health_polygon.scale.x = percentage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_polygon = find_child("Health")
	set_color()
	set_percentage()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if percentage != health_polygon.scale.x:
		set_percentage()
