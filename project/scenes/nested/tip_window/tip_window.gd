extends Node2D

signal done

@export var text: PackedStringArray
var text_index: int = 0

var head_player: AnimationPlayer
var arrow_player: AnimationPlayer
var text_box: AnimatedSprite2D
var label: Label
var current_text: String = ""
var is_done = false

func head_done_growing(_name: String):
	head_player.animation_finished.disconnect(head_done_growing)
	head_player.play("Rotate")
	text_box.show()
	text_box.play("grow")
	text_box.animation_finished.connect(text_box_done_growing)
	
func head_done_shrinking(_name: String):
	head_player.animation_finished.disconnect(head_done_shrinking)
	emit_signal("done")
	
func text_box_done_growing():
	text_box.animation_finished.disconnect(text_box_done_growing)
	typewriter(text[0],
		func ():
			arrow_player.play("Bobbing")
	)
	
func text_box_done_shrinking():
	text_box.hide()
	text_box.animation_finished.disconnect(text_box_done_shrinking)
	head_player.animation_finished.connect(head_done_shrinking)
	head_player.play_backwards("Scale")

func typewriter(text: String, on_finished: Callable = func (): pass):
	label.text = ""
	current_text = text.replace("\\n", "
	")
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(
		func():
			label.text += current_text[0]
			current_text = current_text.substr(1)
			if current_text == "":
				timer.stop()
				remove_child(timer)
				timer.queue_free()
				on_finished.call()
	)
	timer.start(0.01)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head_player = find_child("HeadPlayer")
	head_player.animation_finished.connect(head_done_growing)
	
	arrow_player = find_child("ArrowPlayer")
	
	label = find_child("Label")
	
	text_box = find_child("TextBox")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and current_text == "" and not is_done:
		arrow_player.play("Reset")
		text_index += 1
		if len(text) > text_index:
			typewriter(text[text_index],
				func ():
					arrow_player.play("Bobbing")
			)
		else:
			label.text = ""
			text_box.play_backwards("grow")
			text_box.animation_finished.connect(text_box_done_shrinking)
			is_done = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
