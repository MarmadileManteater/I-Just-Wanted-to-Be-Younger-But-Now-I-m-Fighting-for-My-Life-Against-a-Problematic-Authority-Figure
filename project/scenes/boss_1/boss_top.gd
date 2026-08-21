extends Node2D

class_name Boss1Top

@export var fire_timeout = 2

var projectiles: TextProjectiles
var speech_start: AnimatedSprite2D
var selected_target: Node2D
var head_animation_player: AnimationPlayer

var can_fire: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	projectiles = find_child("Projectiles", true)
	speech_start = find_child("SpeechStart", true)
	head_animation_player = find_child("AnimationPlayer", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire_projectile(target: Node2D) -> void:
	if can_fire:
		can_fire = false
		selected_target = target
		speech_start.play("speech")
		speech_start.animation_finished.connect(speech_bubble_animation_finished)
	
func speech_bubble_animation_finished():
	projectiles.fire(selected_target)
	speech_start.animation_finished.disconnect(speech_bubble_animation_finished)

func _on_projectile_moving() -> void:
	speech_start.play_backwards("speech")
	speech_start.animation_finished.connect(hide_speech_bubble)
	
func hide_speech_bubble():
	speech_start.play("default")
	speech_start.animation_finished.disconnect(hide_speech_bubble)

func _on_projectile_destroyed() -> void:
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(
		func ():
			can_fire = true
			remove_child(timer)
			timer.queue_free()
	)
	timer.start(fire_timeout)
