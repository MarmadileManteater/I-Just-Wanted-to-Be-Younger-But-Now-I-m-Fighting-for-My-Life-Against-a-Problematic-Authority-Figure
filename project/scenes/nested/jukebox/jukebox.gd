extends Node2D

class_name JukeBox

var player: AudioStreamPlayer
var controls: AnimationPlayer
var loop_controls: AnimationPlayer
var effects: AnimationPlayer

var paused_position: int = 0
var audio_effect_callback: Callable
var music_queue: Array = []
var on_track_stopped: Callable = func(is_true: bool): pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = find_child("Jukebox")
	player.finished.connect(
		func ():
			on_track_stopped.call(music_queue.size() == 0)
			if music_queue.size() > 0:
				var music: TrackInfo = music_queue.pop_front()
				play_music(music.name, true)
				change_loop_status(music.loop)
	)
	controls = find_child("JukeboxControls")
	effects = find_child("JukeboxEffects")
	loop_controls = find_child("LoopControls")

func play_music(track_title: String, bypass: bool = false) -> void:
	paused_position = 0
	if controls.last_animation != track_title or bypass:
		effects.play("Playing")
		controls.play_with_memory(track_title)

func play_music_with_fade_in(track_title: String, seconds: float = 1.0) -> void:
	paused_position = 0
	if controls.last_animation != track_title:
		effects.speed_scale = 1 / seconds
		effects.play("PlayWithFadeIn")
		controls.play_with_memory(track_title)

func stop_music() -> void:
	player.stop()
	paused_position = 0

func pause_music() -> void:
	paused_position = player.get_playback_position()
	player.stop()

func unpause_music() -> void:
	player.volume_db = -80
	player.play(paused_position)
	effects.play("PlayWithFadeIn")
	paused_position = 0

func stop_music_with_reverb(callback: Callable = func (): pass, animation_speed: float = 1) -> void:
	audio_effect_callback = callback
	effects.speed_scale = animation_speed
	effects.play("ReverbFadeOut")
	effects.animation_finished.connect(_on_reverb_fade_out)

func fade_out_music(animation_speed: float = 1) -> void:
	effects.play("FadeOut")
	
func change_loop_status(is_looping: bool):
	if is_looping:
		loop_controls.play("Loop")
	else:
		loop_controls.play("NoLoop")
	
func queue_music(track: TrackInfo) -> void:
	if player.playing:
		change_loop_status(false)
		music_queue.push_back(track)
	else:
		change_loop_status(track.loop)
		play_music(track.name, true)
	
func _on_reverb_fade_out(_name: String) -> void:
	effects.play("Stopped")
	effects.animation_finished.disconnect(_on_reverb_fade_out)
	controls.last_animation = ""
	controls.stop()
	audio_effect_callback.call()
	audio_effect_callback = func (): pass
