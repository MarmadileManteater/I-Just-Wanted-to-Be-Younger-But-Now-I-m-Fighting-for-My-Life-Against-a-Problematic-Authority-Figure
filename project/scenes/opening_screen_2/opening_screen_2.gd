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
var podium_player: AnimationPlayer
var tv: Sprite2D
var tv_static: Polygon2D
var news_window: DialogWindow

var animate_space_speed: float = 0

var music_done: bool = false
var bed_dialog_done: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	jump_into_bed_animation_player = find_child("JumpIntoBedAnimationPlayer")
	space_animation_player = find_child("SpaceAnimationPlayer")
	mascot_animation_player = find_child("MascotAnimationPlayer")
	podium_player = find_child("PodiumPlayer")
	mascot = find_child("Mascot")
	bed_dialog = find_child("BedDialog")
	space = find_child("Space")
	shooting_star = find_child("ShootingStar")
	shooting_star_sound = shooting_star.find_child("AudioStreamPlayer")
	mascot_dialog_1 = find_child("MascotDialog1")
	tv = find_child("TV")
	tv_static = tv.find_child("Static")
	news_window = tv.find_child("NewsWindow")

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
	if music_done:
		after_bed_dialog()
	else:
		bed_dialog_done = true

func after_bed_dialog():
	mascot_animation_player.play("MascotLand")
	mascot_animation_player.animation_finished.connect(_on_mascot_land)
		
func _on_mascot_land(_name: String):
	mascot_dialog_1.start()
	mascot_dialog_1.next_line.connect(_on_mascot_dialog_1_line)
	mascot_dialog_1.done.connect(_on_mascot_dialog_1_done)
	animate_space_speed = 10
	emit_signal("change_loop_status", true)
	emit_signal("play_music", "Introduction")
	
func _on_mascot_dialog_1_line(index: int):
	if index == 3:
		mascot.flip_h = true
	if index == 4:
		mascot.flip_h = false
	if index == 6:
		mascot_dialog_1.talking_speed = 0.25
		mascot_dialog_1.set_voice(2)
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
		mascot_dialog_1.talking_speed = 1
		mascot_dialog_1.set_voice(1)
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
	if index == 17:
		podium_player.play("FadeIn")
	if index == 18:
		mascot_dialog_1.set_head(DialogWindow.Head.Willow)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Left)
		mascot_dialog_1.position.x = 556.0
	if index == 20:
		podium_player.play("FadeOut")
		mascot_dialog_1.set_head(DialogWindow.Head.Mascot)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Right)
		mascot_dialog_1.position.x = 425.0
	if index == 23:
		mascot_dialog_1.set_head(DialogWindow.Head.Willow)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Left)
		mascot_dialog_1.position.x = 556.0
	if index == 24:
		mascot_dialog_1.set_head(DialogWindow.Head.Mascot)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Right)
		mascot_dialog_1.position.x = 425.0
	if index == 25:
		willow.transform()
		var timer = Timer.new()
		add_child(timer)
		emit_signal("pause_music")
		timer.timeout.connect(
			func ():
				emit_signal("unpause_music")
				remove_child(timer)
				timer.queue_free()
		)
		timer.start(4)
		mascot_dialog_1.set_head(DialogWindow.Head.WillowTF)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Left)
		mascot_dialog_1.position.x = 556.0
	if index == 28:
		mascot_dialog_1.set_head(DialogWindow.Head.Mascot)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Right)
		mascot_dialog_1.position.x = 425.0
	if index == 30:
		mascot_dialog_1.set_head(DialogWindow.Head.WillowTF)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Left)
		mascot_dialog_1.position.x = 556.0
	if index == 31:
		mascot_dialog_1.set_head(DialogWindow.Head.Mascot)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Right)
		mascot_dialog_1.position.x = 425.0
	if index == 32:
		mascot_dialog_1.set_head(DialogWindow.Head.WillowTF)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Left)
		mascot_dialog_1.position.x = 556.0
	if index == 33:
		mascot_dialog_1.set_head(DialogWindow.Head.Mascot)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Right)
		mascot_dialog_1.position.x = 425.0
	if index == 34:
		mascot_dialog_1.set_head(DialogWindow.Head.WillowTF)
		mascot_dialog_1.set_direction(DialogWindow.Direction.Left)
		mascot_dialog_1.position.x = 556.0
	if index == 35:
		emit_signal("play_music", "TVStatic")
		var timer = Timer.new()
		timer.one_shot = true
		add_child(timer)
		timer.timeout.connect(
			func ():
				tv.show()
				remove_child(timer)
				timer.queue_free()
		)
		timer.start(0.5)
		
func _on_mascot_dialog_1_done():
	emit_signal("play_music", "NewsReel")
	tv_static.hide()
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(
		func ():
			news_window.next_line.connect(_on_news_window_next_line)
			news_window.done.connect(_on_news_window_done)
			news_window.start()
			news_window.set_voice_by_name("Other")
			remove_child(timer)
			timer.queue_free()
	)
	timer.start(1)

func _on_news_window_next_line(index: int):
	if index == 1:
		news_window.set_head(DialogWindow.Head.WillowTF)
		news_window.set_direction(DialogWindow.Direction.Left)
		news_window.position.x = 20
	if index == 3:
		news_window.set_head(DialogWindow.Head.Mascot)
		news_window.set_direction(DialogWindow.Direction.Neither)
		news_window.position.x = -98.486
		news_window.set_voice_by_name("Other")
	if index == 5:
		news_window.set_head(DialogWindow.Head.WillowTF)
		news_window.set_direction(DialogWindow.Direction.Left)
		news_window.position.x = 20
	if index == 7:
		news_window.set_head(DialogWindow.Head.Mascot)
		news_window.set_direction(DialogWindow.Direction.Right)
		news_window.position.x = -217
		emit_signal("play_music", "Gameplay")
		var timer = Timer.new()
		timer.one_shot = true
		timer.timeout.connect(
			func ():
				emit_signal("next_screen", SceneInfo.from_name("boss_1_screen_1"))
		)
		add_child(timer)
		timer.start(5.6)

func _on_news_window_done():
	pass

func on_track_stopped(is_queue_empty: bool) -> void:
	if is_queue_empty:
		if bed_dialog_done:
			after_bed_dialog()
		else:
			music_done = true
