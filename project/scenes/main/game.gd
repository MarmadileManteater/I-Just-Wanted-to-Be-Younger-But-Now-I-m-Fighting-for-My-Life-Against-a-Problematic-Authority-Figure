extends Node2D

@export var start_scene: String = "boss_1_screen_1"

var jukebox_controls: AnimationPlayer
var scene: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jukebox_controls = find_child("JukeboxControls")
	scene = load("res://scenes/" + start_scene + "/" + start_scene + ".tscn").instantiate()
	scene.connect("next_screen", _next_screen)
	scene.connect("play_music", _play_music)
	add_child(scene)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _next_screen(info: SceneInfo) -> void:
	call_deferred("next_screen_deferred", info)

func next_screen_deferred(info: SceneInfo) -> void:
	var next_scene = load("res://scenes/" + info.next_scene + "/" + info.next_scene + ".tscn").instantiate()
	scene.disconnect("next_screen", _next_screen)
	remove_child(scene)
	scene = next_scene
	scene.connect("next_screen", _next_screen)
	scene.connect("play_music", _play_music)
	add_child(scene)
	scene.hearts.health = info.health

func _play_music(track_title: String) -> void:
	if jukebox_controls.current_animation != track_title:
		jukebox_controls.play(track_title)
