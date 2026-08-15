extends Node2D

class_name DefaultScene

signal next_screen

@export var character_name: String = "Willow"
@export var dolly_axis: Dolly.Axis = Dolly.Axis.X
@export var dolly_offset: int = 0
@export var next_scene_name: String

var willow: Willow
var dolly: Dolly
var hearts: HealthDisplay
var next_screen_area: NextScreenArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	willow = find_child(character_name, true, false)
	if willow == null:
		printerr(character_name + " not found!")
	dolly = find_child("Dolly", true, false)
	if dolly != null:
		dolly.lock(willow)
	hearts = find_child("HealthDisplay", true, false)
	if hearts == null:
		printerr("Health display not found!")
	next_screen_area = find_child("NextScreen", true, false)
	if next_screen_area != null:
		next_screen_area.character_name = character_name
		next_screen_area.scene = next_scene_name
		next_screen_area.next_scene.connect(_on_next_screen)

func _on_next_screen(info: SceneInfo) -> void:
	info.health = hearts.health
	emit_signal("next_screen", info)
