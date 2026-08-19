extends DefaultScene

@export var player_threshold: int = 10
@export var boss_speed: int = 2
var boss_top: Boss1Top
var boss_bottom: Node2D
var boss_middle: Node2D
var boss_right: Node2D

var left_hand_limit: Node2D
var right_hand_limit: Node2D

var slam_animation_player: AnimationPlayerExtended
var bob_animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	boss_top = find_child("BossTop")
	boss_bottom = find_child("BossBottom")
	boss_middle = boss_top.find_child("Middle")
	boss_right = boss_top.find_child("Right")
	
	left_hand_limit = find_child("LeftHandLimit")
	right_hand_limit = find_child("RightHandLimit")
	
	slam_animation_player = find_child("SlamAnimationPlayer")
	bob_animation_player = find_child("BobbingAnimationPlayer")
	
	willow.bounce(1.5)

func move_boss_towards(point: Node2D, arm: String = ""):
	if not slam_animation_player.last_animation.begins_with(arm) or arm == "":
		if willow.global_position.x + player_threshold < point.global_position.x:
			if bob_animation_player.current_animation != "Bob":
				bob_animation_player.play("Bob")
			boss_top.position.x -= boss_speed
			boss_bottom.position.x -= boss_speed
		elif willow.global_position.x - player_threshold > point.global_position.x:
			if bob_animation_player.current_animation != "Bob":
				bob_animation_player.play("Bob")
			boss_top.position.x += boss_speed
			boss_bottom.position.x += boss_speed
		else:
			bob_animation_player.pause()
			if arm != "":
				slam_animation_player.play_with_memory(arm + "ArmRaise")
				slam_animation_player.animation_finished.connect(slam_hand)
			else:
				slam_animation_player.play_with_memory("ArmsDown")
				boss_top.fire_projectile(willow)
				

func slam_hand(animation_name: String):
	slam_animation_player.play_with_memory(animation_name.replace("Raise", "Slam"))
	slam_animation_player.animation_finished.disconnect(slam_hand)
	timeout_to_reset_animation(2)

func timeout_to_reset_animation(seconds: float = 1):
	var timeout = Timer.new()
	timeout.timeout.connect(
		func ():
			slam_animation_player.play_with_memory("ArmsDown")
			remove_child(timeout)
			timeout.stop()
	)
	add_child(timeout)
	timeout.start(seconds)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hearts.health > 0:
		if willow.global_position.x < left_hand_limit.global_position.x:
			move_boss_towards(boss_top, "Left")
			dolly.locked_offset = 400
		elif willow.global_position.x > left_hand_limit.global_position.x and willow.global_position.x < right_hand_limit.global_position.x:
			move_boss_towards(boss_middle)
			dolly.locked_offset = 0
		elif willow.global_position.x > right_hand_limit.global_position.x:
			move_boss_towards(boss_right, "Right")
			dolly.locked_offset = -400

func _on_crushed(position: Vector2) -> void:
	hearts.health = 0
	willow.position.y = position.y + 300 # magic number
	willow.die("crushed")


func _on_projectiles_damage() -> void:
	if not willow.invulnerable:
		hearts.health -= 1
		if hearts.health <= 0:
			willow.die("disintegrate")
		else:
			willow.flash()
