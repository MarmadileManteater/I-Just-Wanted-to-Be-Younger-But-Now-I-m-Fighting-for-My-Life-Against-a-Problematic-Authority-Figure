extends DefaultScene

@export var player_threshold: int = 10
@export var boss_speed: int = 1
var boss_top: Node2D
var boss_bottom: Node2D
var boss_middle: Node2D
var boss_right: Node2D

var left_hand_limit: Node2D
var right_hand_limit: Node2D

var slam_animation_player: AnimationPlayer
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

func move_boss_towards(point: Node2D):
	if willow.global_position.x + player_threshold < point.global_position.x:
		if bob_animation_player.current_animation != "Bob":
			bob_animation_player.play("Bob")
		boss_top.position.x -= 1
		boss_bottom.position.x -= 1
	elif willow.global_position.x - player_threshold > point.global_position.x:
		if bob_animation_player.current_animation != "Bob":
			bob_animation_player.play("Bob")
		boss_top.position.x += 1
		boss_bottom.position.x += 1
	else:
		bob_animation_player.pause()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if willow.global_position.x < left_hand_limit.global_position.x:
		move_boss_towards(boss_top)
		dolly.locked_offset = 400
	elif willow.global_position.x > left_hand_limit.global_position.x and willow.global_position.x < right_hand_limit.global_position.x:
		move_boss_towards(boss_middle)
		dolly.locked_offset = 0
	elif willow.global_position.x > right_hand_limit.global_position.x:
		move_boss_towards(boss_right)
		dolly.locked_offset = -400
	else:
		bob_animation_player.pause()
		slam_animation_player.play("ArmsDown")

func _on_crushed() -> void:
	hearts.health = 0
	willow.die("crushed")
