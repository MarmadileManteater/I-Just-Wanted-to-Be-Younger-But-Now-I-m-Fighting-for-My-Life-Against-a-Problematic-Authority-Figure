extends DefaultScene

var jump_into_bed_animation_player: AnimationPlayer
var space_animation_player: AnimationPlayer
var mascot_animation_player: AnimationPlayer
var bed_dialog: DialogWindow
var space: Polygon2D
var shooting_star: AnimatedSprite2D
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
		
func _on_bed_dialog_done():
	mascot_animation_player.play("MascotLand")
	mascot_animation_player.animation_finished.connect(_on_mascot_land)
	
func _on_mascot_land(_name: String):
	mascot_dialog_1.start()
	mascot_dialog_1.next_line.connect(_on_mascot_dialog_1_line)
	animate_space_speed = 10
	#emit_signal("play_music", "Introduction")
	
func _on_mascot_dialog_1_line(index: int):
	if index == 3:
		mascot.flip_h = true
	if index == 4:
		mascot.flip_h = false
