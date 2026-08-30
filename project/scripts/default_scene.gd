extends Node2D

class_name DefaultScene

signal next_screen
signal play_music
signal play_music_with_fade_in
signal queue_music
signal stop_music_with_reverb
signal stop_music
signal pause_music
signal unpause_music
signal play_sound_effect
signal change_loop_status

enum ControllerType { Joypad, Keyboard }

@export var character_name: String = "Willow"
@export var starts_transformed: bool = true
@export var track_name: String = ""
@export var queue_track: bool = false
@export var loop_track: bool = true
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
	willow.is_transformed = starts_transformed
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
		if not queue_track:
			emit_signal("play_music", track_name)
			emit_signal("change_loop_status", loop_track)
		else:
			emit_signal("queue_music", TrackInfo.from(track_name, loop_track))

func lock_dolly():
	dolly.lock(willow, dolly_axis)

func _on_next_screen(info: SceneInfo) -> void:
	if hearts != null:
		info.health = hearts.health
	emit_signal("next_screen", info)
	
func _on_controller_type_changed(new_type: ControllerType):
	controller_type = new_type
	
func die(method: String = ""):
	if willow.die(method):
		hearts.health = 0
		emit_signal("stop_music_with_reverb")
		var timer = Timer.new()
		timer.one_shot = true
		timer.timeout.connect(
			func ():
				var gameover = new_gameover_scene()
				if dolly != null:
					dolly.add_child(gameover)
				else:
					printerr("No dolly found for game over screen!")
				gameover.animation_player.play("FloatIn")
				emit_signal("play_sound_effect", "GameOver")
				remove_child(timer)
				timer.queue_free()
		)
		add_child(timer)
		timer.start(1.5)
		
func new_gameover_scene() -> GameOverScreen:
	var game_over = preload("res://scenes/nested/game_over/game_over.tscn")
	return game_over.instantiate()
	
func on_track_stopped(is_queue_empty: bool) -> void:
	pass
