extends Node2D

class_name GameOverScreen

signal load_checkpoint
signal reset

var animation_player: AnimationPlayer
var choices = ["load_checkpoint", "reset"]
var selection = 0

var return_to_last_check_point_select: Sprite2D
var reset_level_select: Sprite2D
var selects = []

var return_to_last_check_point_player: AnimationPlayer
var reset_level_player: AnimationPlayer
var players = []

var move_audio: AudioStreamPlayer
var select_audio: AudioStreamPlayer

var locked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player = find_child("AnimationPlayer")
	return_to_last_check_point_select = $ReturnToLastCheckPoint/Select
	reset_level_select = $ResetLevel/Select
	selects = [return_to_last_check_point_select, reset_level_select]
	
	return_to_last_check_point_player = $ReturnToLastCheckPoint/AnimationPlayer
	reset_level_player = $ResetLevel/AnimationPlayer
	players = [return_to_last_check_point_player, reset_level_player]
	move_audio = $Move
	select_audio = $Select

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if locked:
		return
	if animation_player.current_animation == "FloatIn":
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left"):
			animation_player.speed_scale = 100000
	else:
		if event.is_action_pressed("ui_left"):
			if selection == 1:
				selects[selection].hide()
				selection = 0
				selects[selection].show()
				move_audio.play()
		if event.is_action_pressed("ui_right"):
			if selection == 0:
				selects[selection].hide()
				selection = 1
				selects[selection].show()
				move_audio.play()
		if event.is_action_pressed("ui_accept"):
			locked = true
			players[selection].animation_finished.connect(
				func (name):
					emit_signal(choices[selection])
					locked = false
			)
			players[selection].play("Flash")
			select_audio.play()
