extends Node2D

class_name DialogWindow

signal done
signal next_line

enum Direction { Left, Right, Neither }
enum Head { Mascot, Willow, WillowTF }

@export var autostart: bool = false
@export var text: PackedStringArray
@export var direction: Direction = Direction.Left
@export var talking_head: Head = Head.Mascot
@export var talking_speed: float = 1
var text_index: int = 0

var default_head_position: Vector2
var default_text_box_position: Vector2
var default_text_box_scale: int
var default_label_position: Vector2

var head: Sprite2D
var head_scaler: Node2D
var head_player: AnimationPlayer
var arrow_player: AnimationPlayer
var head_chooser: AnimationPlayer
var text_box: AnimatedSprite2D
var label: RichTextLabel
var sound_effect_player: AudioStreamPlayer
var voice_chooser: AnimationPlayer

var current_text: String = ""
var is_active = false
var is_done = false

func set_voice_by_name(voice_name: String):
	voice_chooser.play(voice_name)

func set_voice(voice_number: int = 1):
	var voice_text = ""
	if voice_number > 1:
		voice_text = "%s" % voice_number
	if talking_head == Head.Willow:
		voice_chooser.play("Willow%s" % voice_text)
	if talking_head == Head.Mascot:
		voice_chooser.play("Mascot%s" % voice_text)

func set_head(given: Head):
	talking_head = given
	if talking_head == Head.Willow:
		head_scaler.scale = Vector2(0.8, 0.8)
		head_chooser.play("Willow")
		head_chooser.stop()
		voice_chooser.play("Willow")
	if talking_head == Head.WillowTF:
		head_scaler.scale = Vector2(0.8, 0.8)
		head_chooser.play("Willow_2")
		head_chooser.stop()
		voice_chooser.play("Willow")
	if talking_head == Head.Mascot:
		head_scaler.scale = Vector2(1, 1)
		head_chooser.play("Mascot")
		head_chooser.stop()
		voice_chooser.play("Mascot")

func set_direction(given: Direction):
	direction = given
	
	head.position = default_head_position
	text_box.position = default_text_box_position
	text_box.scale.x = default_text_box_scale
	label.position = default_label_position 
	
	head.show()
	text_box.play_backwards("grow")
	text_box.pause()
	
	if direction == Direction.Right:
		head.position.x -= 800
		text_box.scale.x = -1
		text_box.position.x += 150
		label.position.x += 190
		
	if direction == Direction.Neither:
		head.hide()
		text_box.position.x += 80
		label.position.x += 100
		text_box.play_backwards("grow_middle")
		text_box.pause()

func start():
	current_text = "Loading . . . "
	is_active = true
	is_done = false
	head_player.play("Scale")
	head_player.animation_finished.connect(head_done_growing)
	set_direction(direction)

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
				var keep_going = true
				while keep_going:
					string += current_text[index]
					index += 1
					if string.ends_with("]") and not string.begins_with("[img"):
						keep_going = false
					if string.begins_with("[img") and string.ends_with("/img]"):
						keep_going = false
			elif current_text.length() > 0:
				string = current_text[0]
			if string.length() == 1 and string != " ":
				if not sound_effect_player.playing:
					sound_effect_player.play()
			label.text += string
			current_text = current_text.substr(len(string))
			if current_text == "":
				timer.stop()
				remove_child(timer)
				timer.queue_free()
				on_finished.call()
	)
	timer.start(1 / (talking_speed * 100))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head_scaler = find_child("HeadScaler")
	head = find_child("MascotHead", true)
	head_player = find_child("HeadPlayer")
	arrow_player = find_child("ArrowPlayer")
	head_chooser = find_child("HeadChooser")
	
	label = find_child("Label")
	#label.add_image(preload(""), 100, 84, Color(1, 1, 1, 1), 0, Rect2(), "left_face_buttona")
	
	text_box = find_child("TextBox")
	
	sound_effect_player = find_child("AudioStreamPlayer")
	voice_chooser = find_child("VoiceChooser")
	
	default_head_position = head.position
	default_text_box_position = text_box.position
	default_text_box_scale = text_box.scale.x
	default_label_position = label.position
	
	set_head(talking_head)
	
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
