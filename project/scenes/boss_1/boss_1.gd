extends DefaultScene

@export var boss_health: int = 100
@export var boss_stage: int = 1

@export var player_threshold: int = 10
@export var boss_speed: int = 2

var stage_changing: bool = false
var boss_started: bool = false

var boss_top: Boss1Top
var boss_bottom: Node2D
var boss_middle: Node2D
var boss_right: Node2D
var wand_pickup: RigidBody2D

var left_hand_limit: Node2D
var right_hand_limit: Node2D

var slam_animation_player: AnimationPlayerExtended
var bob_animation_player: AnimationPlayer
var drop_animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	boss_top = find_child("BossTop")
	boss_bottom = find_child("BossBottom")
	boss_middle = boss_top.find_child("Middle")
	boss_right = boss_top.find_child("Right")
	wand_pickup = find_child("WandPickup")
	
	left_hand_limit = find_child("LeftHandLimit")
	right_hand_limit = find_child("RightHandLimit")
	
	slam_animation_player = find_child("SlamAnimationPlayer")
	bob_animation_player = find_child("BobbingAnimationPlayer")
	drop_animation_player = find_child("DropPlayer", true)
	
	willow.bounce(1.5)

func move_boss_towards(point: Node2D, arm: String = ""):
	if (not slam_animation_player.last_animation.begins_with(arm) or arm == "") or (boss_stage >= 2 and slam_animation_player.last_animation.ends_with("Slam")):
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
		elif not slam_animation_player.last_animation.begins_with(arm) or arm == "":
			bob_animation_player.pause()
			if arm != "":
				slam_animation_player.play_with_memory(arm + "ArmRaise")
				if not slam_animation_player.animation_finished.is_connected(slam_hand):
					slam_animation_player.animation_finished.connect(slam_hand)
			else:
				slam_animation_player.play_with_memory("ArmsDown")
				boss_top.fire_projectile(willow)
				

func slam_hand(animation_name: String):
	slam_animation_player.play_with_memory(animation_name.replace("Raise", "Slam"))
	slam_animation_player.animation_finished.disconnect(slam_hand)
	if boss_stage == 1:
		timeout_to_reset_animation(2)
	else:
		timeout_to_reset_animation(5)

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

func stage_change(stage: int):
	if not stage_changing and stage > boss_stage:
		boss_stage = stage
		stage_changing = true
		slam_animation_player.pause()
		boss_top.head_animation_player.animation_finished.connect(after_stage_change)
		boss_top.head_animation_player.play("Stage Change")

func after_stage_change(name: String):
	stage_changing = false
	slam_animation_player.play()
	boss_top.head_animation_player.animation_finished.disconnect(after_stage_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not boss_started:
		return
	if stage_changing:
		return
	if boss_stage >= 3:
		boss_speed = 4
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

func _on_damage_boss() -> void:
	boss_health -= 1
	if boss_health < 75:
		stage_change(2)
	if boss_health < 25:
		stage_change(3)
	if boss_health < 0:
		# TODO proper death sequence
		boss_top.hide()
		boss_bottom.hide()

func _on_death_zone_entered(body: Node2D) -> void:
	if body == willow:
		willow.die()
		hearts.health = 0

func _on_tip_window_done() -> void:
	willow.controls_locked = false
	drop_animation_player.play("Drop")


func _on_pickup_window_entered(body: Node2D) -> void:
	if body == willow and not boss_started:
		lock_dolly()
		willow.activate_wand() 
		remove_child(wand_pickup)
		boss_started = true
		find_child("AudioStreamPlayer2D", true).play()
