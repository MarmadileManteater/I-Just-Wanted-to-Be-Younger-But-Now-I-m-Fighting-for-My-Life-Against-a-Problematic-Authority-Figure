extends Node2D

@export var start_scene: String = "boss_1_screen_1"
var scene: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene = load("res://scenes/" + start_scene + "/" + start_scene + ".tscn").instantiate()
	add_child(scene)
	scene.connect("next_screen", _next_screen)
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
	add_child(scene)
	scene.hearts.health = info.health
	scene.connect("next_screen", _next_screen)
