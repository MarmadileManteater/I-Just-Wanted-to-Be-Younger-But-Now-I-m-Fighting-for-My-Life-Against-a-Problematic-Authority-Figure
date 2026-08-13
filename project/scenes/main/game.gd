extends Node2D

var scene: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene = preload("res://scenes/boss_1_screen_1/boss_1_screen_1.tscn").instantiate()
	add_child(scene)
	scene.connect("next_screen", _next_screen)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _next_screen(info: SceneInfo) -> void:
	var next_scene = load("res://scenes/" + info.next_scene + "/" + info.next_scene + ".tscn").instantiate()
	scene.disconnect("next_screen", _next_screen)
	remove_child(scene)
	scene = next_scene
	add_child(scene)
	scene.hearts.health = info.health
	scene.connect("next_screen", _next_screen)
	
