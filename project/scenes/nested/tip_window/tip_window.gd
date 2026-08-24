extends Node2D

class_name DialogWindow

signal done
signal next_line

enum Direction { Left, Right, Neither }
enum Head { Mascot, Willow }

@export var autostart: bool = false
@export var text: PackedStringArray
@export var direction: Direction = Direction.Left
@export var talking_head: Head = Head.Mascot
var text_index: int = 0

var head: Sprite2D
var head_player: AnimationPlayer
var arrow_player: AnimationPlayer
var head_chooser: AnimationPlayer
var text_box: AnimatedSprite2D
var label: RichTextLabel
var current_text: String = ""
var is_active = false
var is_done = false

func start():
	is_active = true
	is_done = false
	head_player.play("Scale")
	head_player.animation_finished.connect(head_done_growing)
	if direction == Direction.Right:
		head.position.x -= 800
		text_box.scale.x = -1
		text_box.position.x += 150
		label.position.x += 190
		
	if direction == Direction.Neither:
		head.hide()
		text_box.position.x += 80
		label.position.x += 100

func head_done_growing(_name: String):
	head_player.animation_finished.disconnect(head_done_growing)
	head_player.play("Rotate")
	text_box.show()
	if direction == Direction.Neither:
		text_box.play("grow_middle")
	else:
		text_box.play("grow")
	text_box.animation_finished.connect(text_box_done_growing)
	
func head_done_shrinking(_name: String):
	head_player.animation_finished.disconnect(head_done_shrinking)
	is_active = false
	emit_signal("done")
	
func text_box_done_growing():
	text_box.animation_finished.disconnect(text_box_done_growing)
	typewriter(text[0],
		func ():
			if direction == Direction.Left:
				arrow_player.play("Bobbing")
			elif direction == Direction.Right:
				arrow_player.play("BobbingRight")
			else:
				arrow_player.play("BobbingMiddle")
	)
	
func text_box_done_shrinking():
	text_box.hide()
	text_box.animation_finished.disconnect(text_box_done_shrinking)
	head_player.animation_finished.connect(head_done_shrinking)
	head_player.play_backwards("Scale")

func typewriter(given_text: String, on_finished: Callable = func (): pass):
	label.text = ""
	current_text = given_text.replace("\\n", "
")
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(
		func():
			var string = ""
			if current_text.begins_with("["):
				var index = 0
				while not string.ends_with("]"):
					string += current_text[index]
					index += 1
			elif current_text.length() > 0:
				string = current_text[0]
			label.text += string
			current_text = current_text.substr(len(string))
			if current_text == "":
				timer.stop()
				remove_child(timer)
				timer.queue_free()
				on_finished.call()
	)
	timer.start(0.01)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head = find_child("MascotHead")
	head_player = find_child("HeadPlayer")
	arrow_player = find_child("ArrowPlayer")
	head_chooser = find_child("HeadChooser")
	
	label = find_child("Label")
	
	text_box = find_child("TextBox")
	
	if talking_head == Head.Willow:
		head_chooser.play("Willow")
		head_chooser.stop()
	if talking_head == Head.Mascot:
		head_chooser.play("Mascot")
		head_chooser.stop()
	
	if autostart:
		start()


func _input(event: InputEvent) -> void:
	if is_active:
		if event.is_action_pressed("ui_accept") and current_text == "" and not is_done:
			arrow_player.play("Reset")
			text_index += 1
			if text.size() > text_index:
				emit_signal("next_line", text_index)
				typewriter(text[text_index],
					func ():
						if direction == Direction.Left:
							arrow_player.play("Bobbing")
						elif direction == Direction.Right:
							arrow_player.play("BobbingRight")
						else:
							arrow_player.play("BobbingMiddle")
				)
			else:
				label.text = ""
				if direction == Direction.Neither:
					text_box.play_backwards("grow_middle")
				else:
					text_box.play_backwards("grow")
				text_box.animation_finished.connect(text_box_done_shrinking)
				is_done = true
	pass
