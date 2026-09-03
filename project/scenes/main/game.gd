extends Node2D

@export var start_scene: String = "boss_1_screen_1"

var jukebox: AudioStreamPlayer
var jukebox_controls: AnimationPlayerExtended
var loop_controls: AnimationPlayer
var jukebox_effects: AnimationPlayer
var soundbox_controls: AnimationPlayer
var scene: DefaultScene = null
var controller_type: DefaultScene.ControllerType =  DefaultScene.ControllerType.Keyboard
var music_queue: Array = []

var audio_effect_callback: String = ""
var paused_position: float = 0
var checkpoint_scene = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jukebox = find_child("Jukebox")
	
	jukebox.finished.connect(
		func ():
			scene.on_track_stopped(music_queue.size() == 0)
			if music_queue.size() > 0:
				var music: TrackInfo = music_queue.pop_front()
				_play_music(music.name, true)
				_change_loop_status(music.loop)
	)
	
	jukebox_controls = find_child("JukeboxControls")
	loop_controls = find_child("LoopControls")
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
		func ():
			_save_checkpoint(info.next_scene)
	)
	scene.connect("load_checkpoint", _restore_checkpoint)
	add_child(scene)
	if scene.hearts != null:
		scene.hearts.health = info.health

func _change_loop_status(is_looping: bool):
	if is_looping:
		loop_controls.play("Loop")
	else:
		loop_controls.play("NoLoop")

func _play_sound_effect(track_title: String) -> void:
	soundbox_controls.play(track_title)

func _queue_music(track: TrackInfo) -> void:
	if jukebox.playing:
		_change_loop_status(false)
		music_queue.push_back(track)
	else:
		_change_loop_status(track.loop)
		_play_music(track.name, true)
	
func _play_music(track_title: String, bypass: bool = false) -> void:
	paused_position = 0
	if jukebox_controls.last_animation != track_title or bypass:
		jukebox_effects.play("Playing")
		jukebox_controls.play_with_memory(track_title)
		
func _play_music_with_fade_in(track_title: String, seconds: float = 1.0) -> void:
	paused_position = 0
	if jukebox_controls.last_animation != track_title:
		jukebox_effects.speed_scale = 1 / seconds
		jukebox_effects.play("PlayWithFadeIn")
		jukebox_controls.play_with_memory(track_title)

func _stop_music() -> void:
	jukebox.stop()
	paused_position = 0

func _pause_music() -> void:
	paused_position = jukebox.get_playback_position()
	jukebox.stop()
	
func _unpause_music() -> void:
	jukebox.volume_db = -80
	jukebox.play(paused_position)
	jukebox_effects.play("PlayWithFadeIn")
	paused_position = 0

func _stop_music_with_reverb(callback: String = "", animation_speed: float = 1) -> void:
	audio_effect_callback = callback
	jukebox_effects.speed_scale = animation_speed
	jukebox_effects.play("ReverbFadeOut")
	jukebox_effects.animation_finished.connect(_on_reverb_fade_out)
	
func _on_reverb_fade_out(_name: String) -> void:
	jukebox_effects.play("Stopped")
	jukebox_effects.animation_finished.disconnect(_on_reverb_fade_out)
	jukebox_controls.last_animation = ""
	jukebox_controls.stop()
	if scene.has_method(audio_effect_callback):
		var method: Callable = scene[audio_effect_callback]
		method.call()
		audio_effect_callback = ""
		
func _save_checkpoint(scene_name: String) -> void:
	checkpoint_scene = scene_name
	
func _restore_checkpoint() -> void:
	
	jukebox_effects.stop()
	soundbox_controls.play("Reset")
	jukebox_effects.animation_finished.disconnect(_on_reverb_fade_out)
	jukebox_effects.play("Playing")
	next_screen_deferred(SceneInfo.checkpoint(checkpoint_scene))
