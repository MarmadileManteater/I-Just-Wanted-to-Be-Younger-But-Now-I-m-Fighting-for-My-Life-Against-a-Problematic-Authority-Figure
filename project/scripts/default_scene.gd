extends Node2D

class_name DefaultScene

signal next_screen
signal play_music

enum ControllerType { Joypad, Keyboard }

@export var character_name: String = "Willow"
@export var track_name: String = ""
@export var dolly_axis: Dolly.Axis = Dolly.Axis.X
@export var dolly_offset: int = 0
@export var dolly_starts_locked: bool = true
@export var next_scene_name: String

var controller_type: ControllerType

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
		if dolly_starts_locked:
			dolly.lock(willow, dolly_axis)
		dolly.locked_offset = dolly_offset
	hearts = find_child("HealthDisplay", true, false)
	if hearts == null:
		printerr("Health display not found!")
	next_screen_area = find_child("NextScreen", true, false)
	if next_screen_area != null:
		next_screen_area.character_name = character_name
		next_screen_area.scene = next_scene_name
		next_screen_area.next_scene.connect(_on_next_screen)
	if track_name != "":
		emit_signal("play_music", track_name)

func lock_dolly():
	dolly.lock(willow, dolly_axis)

func _on_next_screen(info: SceneInfo) -> void:
	if hearts != null:
		info.health = hearts.health
	emit_signal("next_screen", info)
	
func _on_controller_type_changed(new_type: ControllerType):
	controller_type = new_type
