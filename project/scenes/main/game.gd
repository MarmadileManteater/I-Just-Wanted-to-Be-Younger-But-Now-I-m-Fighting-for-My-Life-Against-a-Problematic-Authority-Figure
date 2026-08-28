extends Node2D

@export var start_scene: String = "boss_1_screen_1"

var jukebox_controls: AnimationPlayerExtended
var jukebox_effects: AnimationPlayer
var soundbox_controls: AnimationPlayer
var scene: DefaultScene = null
var controller_type: DefaultScene.ControllerType =  DefaultScene.ControllerType.Keyboard

var audio_effect_callback: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jukebox_controls = find_child("JukeboxControls")
	jukebox_effects = find_child("JukeboxEffects")
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
	scene.connect("play_music", _play_music)
	scene.connect("stop_music_with_reverb", _stop_music_with_reverb)
	scene.connect("play_sound_effect", _play_sound_effect)
	add_child(scene)
	if scene.hearts != null:
		scene.hearts.health = info.health

func _play_sound_effect(track_title: String) -> void:
	soundbox_controls.play(track_title)

func _play_music(track_title: String) -> void:
	if jukebox_controls.last_animation != track_title:
		jukebox_controls.play_with_memory(track_title)

func _stop_music_with_reverb(callback: String = "") -> void:
	audio_effect_callback = callback
	jukebox_effects.play("ReverbFadeOut")
	jukebox_effects.animation_finished.connect(_on_reverb_fade_out)
	
func _on_reverb_fade_out(_name: String) -> void:
	jukebox_effects.play("Default")
	jukebox_effects.animation_finished.disconnect(_on_reverb_fade_out)
	jukebox_controls.last_animation = ""
	jukebox_controls.stop()
	if scene.has_method(audio_effect_callback):
		var method: Callable = scene[audio_effect_callback]
		method.call()
		audio_effect_callback = ""
