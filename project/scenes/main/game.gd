extends Node2D

@export var start_scene: String = "boss_1_screen_1"

var jukebox: JukeBox
var soundbox_controls: AnimationPlayer
var scene: DefaultScene = null
var controller_type: DefaultScene.ControllerType =  DefaultScene.ControllerType.Keyboard

var audio_effect_callback: String = ""
var checkpoint_data: SceneInfo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jukebox = generate_jukebox()
	add_child(jukebox)
	soundbox_controls = find_child("SoundboxControls")
	
	next_screen_deferred(SceneInfo.from_name(start_scene))
	
func _input(event: InputEvent) -> void:
	var new_type = controller_type
	if event.device == InputEvent.DEVICE_ID_KEYBOARD:
		new_type =  DefaultScene.ControllerType.Keyboard
	elif event.device == InputEvent.DEVICE_ID_MOUSE:
		pass# ignore mouse input
	else:
		new_type =  DefaultScene.ControllerType.Joypad
	if new_type != controller_type:
		controller_type = new_type
		scene._on_controller_type_changed(controller_type)

func _next_screen(info: SceneInfo) -> void:
	call_deferred("next_screen_deferred", info)

func next_screen_deferred(info: SceneInfo) -> void:
	var next_scene = load("res://scenes/" + info.next_scene + "/" + info.next_scene + ".tscn").instantiate()
	if scene != null:
		scene.disconnect("next_screen", _next_screen)
		remove_child(scene)
	scene = next_scene
	scene.connect("next_screen", _next_screen)
	scene.connect("queue_music", _queue_music)
	scene.connect("play_music", _play_music)
	scene.connect("play_music_with_fade_in", _play_music_with_fade_in)
	scene.connect("stop_music_with_reverb", _stop_music_with_reverb)
	scene.connect("stop_music", _stop_music)
	scene.connect("pause_music", _pause_music)
	scene.connect("unpause_music", _unpause_music)
	scene.connect("play_sound_effect", _play_sound_effect)
	scene.connect("change_loop_status", _change_loop_status)
	scene.connect("save_checkpoint", 
		func (checkpoint_data: SceneInfo = SceneInfo.new()):
			if checkpoint_data.next_scene == "":
				checkpoint_data.next_scene = info.next_scene
			_save_checkpoint(checkpoint_data)
	)
	scene.connect("load_checkpoint", _restore_checkpoint)
	scene.starting_health = info.health
	scene.checkpoint_flags = info.checkpoint_flags
	scene.controller_type = controller_type
	add_child(scene)

func _change_loop_status(is_looping: bool):
	jukebox.change_loop_status(is_looping)

func _play_sound_effect(track_title: String) -> void:
	soundbox_controls.play(track_title)

func _queue_music(track: TrackInfo) -> void:
	jukebox.queue_music(track)
	
func _play_music(track_title: String, bypass: bool = false) -> void:
	jukebox.play_music(track_title, bypass)
		
func _play_music_with_fade_in(track_title: String, seconds: float = 1.0) -> void:
	jukebox.play_music_with_fade_in(track_title, seconds)

func _stop_music() -> void:
	jukebox.stop_music()

func _pause_music() -> void:
	jukebox.pause_music()
	
func _unpause_music() -> void:
	jukebox.unpause_music()

func _stop_music_with_reverb(callback: String = "", animation_speed: float = 1) -> void:
	audio_effect_callback = callback
	jukebox.stop_music_with_reverb(
		func ():
			if scene.has_method(audio_effect_callback):
				var method: Callable = scene[audio_effect_callback]
				method.call()
				audio_effect_callback = ""
	,
	animation_speed)

func generate_jukebox() -> JukeBox:
	var jukebox = preload("res://scenes/nested/jukebox/jukebox.tscn").instantiate()
	jukebox.on_track_stopped = func(is_true):
		scene.on_track_stopped(is_true)
	return jukebox

func _save_checkpoint(given: SceneInfo) -> void:
	checkpoint_data = given
	
func _restore_checkpoint() -> void:
	soundbox_controls.play("Reset")
	remove_child(jukebox)
	jukebox.queue_free()
	jukebox = generate_jukebox()
	add_child(jukebox)
	next_screen_deferred(checkpoint_data)
