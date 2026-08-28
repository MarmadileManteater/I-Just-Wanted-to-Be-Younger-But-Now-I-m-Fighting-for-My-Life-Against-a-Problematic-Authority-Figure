extends DefaultScene

var jump_into_bed_animation_player: AnimationPlayer
var space_animation_player: AnimationPlayer
var mascot_animation_player: AnimationPlayer
var bed_dialog: DialogWindow
var space: Polygon2D
var shooting_star: AnimatedSprite2D
var shooting_star_sound: AudioStreamPlayer
var mascot_dialog_1: DialogWindow
var mascot: AnimatedSprite2D

var animate_space_speed: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	jump_into_bed_animation_player = find_child("JumpIntoBedAnimationPlayer")
	space_animation_player = find_child("SpaceAnimationPlayer")
	mascot_animation_player = find_child("MascotAnimationPlayer")
	mascot = find_child("Mascot")
	bed_dialog = find_child("BedDialog")
	space = find_child("Space")
	shooting_star = find_child("ShootingStar")
	shooting_star_sound = shooting_star.find_child("AudioStreamPlayer")
	mascot_dialog_1 = find_child("MascotDialog1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	space.texture_offset.y -= animate_space_speed * delta

func _bed_animation_body_entered(body: Node2D) -> void:
	if body == willow:
		willow.controls_locked = true
		jump_into_bed_animation_player.play("JumpIntoBed")
		jump_into_bed_animation_player.animation_finished.connect(jumped_into_bed)

func jumped_into_bed(_name: String) -> void:
	jump_into_bed_animation_player.animation_finished.disconnect(jumped_into_bed)
	bed_dialog.start()
	bed_dialog.next_line.connect(_on_bed_dialog_line)
	bed_dialog.done.connect(_on_bed_dialog_done)
	
func _on_bed_dialog_line(index: int):
	if index == 3:
		space_animation_player.play("Reveal")
	if index == 7:
		shooting_star.play("shoot")
		shooting_star_sound.play()
		
func _on_bed_dialog_done():
	mascot_animation_player.play("MascotLand")
	mascot_animation_player.animation_finished.connect(_on_mascot_land)
	
func _on_mascot_land(_name: String):
	mascot_dialog_1.start()
	mascot_dialog_1.next_line.connect(_on_mascot_dialog_1_line)
	animate_space_speed = 10
	emit_signal("play_music", "Introduction")
	
func _on_mascot_dialog_1_line(index: int):
	if index == 3:
		mascot.flip_h = true
	if index == 4:
		mascot.flip_h = false
	if index == 6:
		mascot.flip_h = false
		var timer = Timer.new()
		timer.one_shot = true
		timer.timeout.connect(
			func():
				willow.animation_locked = true
				willow.face(Willow.DIRECTION.LEFT)
				willow.change_animation("sit")
				jump_into_bed_animation_player.play("SitUp")
				remove_child(timer)
				timer.queue_free()
		)
		add_child(timer)
		timer.start(0.5)
	if index == 7:
		mascot_dialog_1.set_head(DialogWindow.Head.Willow)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Left)
		mascot_dialog_1.position.x = 556.0
		jump_into_bed_animation_player.play("SitUpDone")
	if index == 9:
		mascot_dialog_1.set_head(DialogWindow.Head.Mascot)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Right)
		mascot_dialog_1.position.x = 425.0
	if index == 10:
		mascot_dialog_1.set_head(DialogWindow.Head.Willow)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Left)
		mascot_dialog_1.position.x = 556.0
	if index == 12:
		mascot_dialog_1.set_head(DialogWindow.Head.Mascot)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Right)
		mascot_dialog_1.position.x = 425.0
	if index == 14:
		mascot_dialog_1.set_head(DialogWindow.Head.Willow)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Left)
		mascot_dialog_1.position.x = 556.0
	if index == 15:
		mascot_dialog_1.set_head(DialogWindow.Head.Mascot)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Right)
		mascot_dialog_1.position.x = 425.0
	if index == 18:
		mascot_dialog_1.set_head(DialogWindow.Head.Willow)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Left)
		mascot_dialog_1.position.x = 556.0
	if index == 20:
		mascot_dialog_1.set_head(DialogWindow.Head.Mascot)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Right)
		mascot_dialog_1.position.x = 425.0
