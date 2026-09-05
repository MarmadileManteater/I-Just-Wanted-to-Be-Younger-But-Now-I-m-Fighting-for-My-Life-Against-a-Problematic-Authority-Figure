extends DefaultScene

@export var boss_health: int = 100
@export var boss_stage: int = 1

@export var player_threshold: int = 10
@export var boss_speed: float = 2

var stage_changing: bool = false
var boss_started: bool = false
var boss_dead: bool = false
var boss_gone: bool = false

var boss_top: Boss1Top
var boss_bottom: Node2D
var boss_middle: Node2D
var boss_right: Node2D
var wand_pickup: RigidBody2D
var first_tip: DialogWindow
var wand_tip: DialogWindow
var post_battle_dialog: DialogWindow
var boss_health_bar: BossHealthBar

var left_hand_limit: Node2D
var right_hand_limit: Node2D

var slam_animation_player: AnimationPlayerExtended
var bob_animation_player: AnimationPlayer
var drop_animation_player: AnimationPlayer
var boss_health_bar_animation_player: AnimationPlayer
var cover_animation_player: AnimationPlayer

var boss_number = 1

func last_track_stopped() -> void:
	emit_signal("play_music", "Tutorial")

func start_boss_music() -> void:
	emit_signal("play_music", "Boss1Phase1")

func start_boss_music_2() -> void:
	emit_signal("play_music", "Boss1Phase2")
	
func start_boss_music_3() -> void:
	emit_signal("play_music", "Boss1Phase3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	emit_signal("stop_music_with_reverb", "last_track_stopped", 4)
	boss_top = find_child("BossTop")
	boss_bottom = find_child("BossBottom")
	boss_middle = boss_top.find_child("Middle")
	boss_right = boss_top.find_child("Right")
	wand_pickup = find_child("WandPickup")
	
	first_tip = dolly.find_child("TipWindow")
	wand_tip = dolly.find_child("TipWindow2")
	post_battle_dialog = dolly.find_child("TipWindow3")
	boss_health_bar = dolly.find_child("BossHealthBar")
	boss_health_bar_animation_player = dolly.find_child("BossHealthBarAnimationPlayer")
	cover_animation_player = dolly.find_child("CoverAnimationPlayer")
	
	left_hand_limit = find_child("LeftHandLimit")
	right_hand_limit = find_child("RightHandLimit")
	
	slam_animation_player = find_child("SlamAnimationPlayer")
	bob_animation_player = find_child("BobbingAnimationPlayer")
	drop_animation_player = find_child("DropPlayer", true)
	
	willow.bounce(1.5)
	
	if checkpoint_flags.size() == 0:
		emit_signal("stop_timer")
		if current_score == 30:
			first_tip.text.insert(0, "That's a perfect score!")
		if current_score > 0:
			first_tip.text.insert(0, "You scored %d on the agility and dexterity section." % current_score)
		else:
			first_tip.text.insert(0, "You didn't score any points in the agility section???")
			first_tip.text[1] = "Wow, that's going to be tough to come back from."
		dolly.find_child("TipWindow").start()
		emit_signal("save_checkpoint", SceneInfo.from_hearts(hearts.health))
	elif checkpoint_flags[0] == true:
		_on_tip_window_done()
		_on_controller_type_changed(controller_type)

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
	# note: can change this timeout based on stage to boost difficulty
	if boss_stage == 1:
		timeout_to_reset_animation(2)
	if boss_stage == 2:
		timeout_to_reset_animation(2)
	if boss_stage == 3:
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

func stage_change(stage: int):
	if not stage_changing and stage > boss_stage:
		if stage == 2:
			emit_signal("stop_music_with_reverb", "start_boss_music_2", 15)
		if stage == 3:
			emit_signal("stop_music_with_reverb", "start_boss_music_3", 15)
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
	var time_var = Helpers.get_time_var(delta) * 2
	print(time_var)
	if not boss_started:
		return
	if boss_gone:
		return
	if boss_dead:
		boss_top.position.y += 2 * time_var
		boss_bottom.position.y += 2 * time_var
		return
	if stage_changing:
		return
	if boss_stage == 1:
		boss_speed = 2 * time_var
	if boss_stage >= 2:
		boss_speed = 2.5 * time_var
	if boss_stage >= 3:
		boss_speed = 3.5 * time_var
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
	die("crushed")

func _on_projectiles_damage() -> void:
	if not willow.invulnerable:
		hearts.health -= 1
		if hearts.health <= 0:
			die("disintegrate")
		else:
			willow.flash()
			willow.hurt()

func _on_damage_boss() -> void:
	boss_top.hurt_sound_effect.play()
	boss_health -= 1
	var health_percentage = 1.0
	if boss_health > 75:
		health_percentage = ( boss_health - 75 ) / 25.0
	elif boss_health > 25:
		health_percentage = ( boss_health - 25 ) / 50.0
		boss_health_bar.set_color(Color(0.922, 0.522, 0.0))
		stage_change(2)
	elif boss_health > 0:
		health_percentage = boss_health / 25.0
		boss_health_bar.set_color(Color(0.955, 0.0, 0.209))
		stage_change(3)
	elif boss_health <= 0:
		boss_death()
		health_percentage = 0
		boss_health_bar_animation_player.play("LoadOut")
	if not boss_top.head_animation_player.current_animation == "Stage Change" and not boss_health_bar_animation_player.current_animation == "LoadIn":
		boss_health_bar.set_percentage(health_percentage)

func _on_death_zone_entered(body: Node2D) -> void:
	if body == willow:
		die()

func _on_tip_window_done() -> void:
	emit_signal("save_checkpoint", SceneInfo.checkpoint(hearts.health, [true]))
	willow.controls_locked = false
	drop_animation_player.play("Drop")

func _on_pickup_window_entered(body: Node2D) -> void:
	if body == willow and not boss_started:
		willow.activate_wand() 
		remove_child(wand_pickup)
		willow.controls_locked = true
		wand_tip.start()   
		wand_tip.done.connect(
			func ():
				boss_health_bar_animation_player.play("LoadIn")
				willow.controls_locked = false
				lock_dolly()
				boss_started = true
				emit_signal("stop_music_with_reverb", "start_boss_music", 100)
		)
		
func boss_death() -> void:
	boss_dead = true
	bob_animation_player.play("Death")
	slam_animation_player.pause()

func _on_boss_death_area_area_entered(area: Area2D) -> void:
	if area.name == "HeadArea":	
		boss_gone = true
		emit_signal("stop_music_with_reverb", "", 20)
		end_game()
		
func end_game():
	willow.controls_locked = true
	post_battle_dialog.start()
	post_battle_dialog.done.connect(
		func ():
			cover_animation_player.play("EndScene")
			cover_animation_player.animation_finished.connect(
				func (name: String):
					var info = SceneInfo.from_name("podium")
					info.health = hearts.health
					emit_signal("next_screen", info)
			)
	)
	
func _on_controller_type_changed(new_type: ControllerType):
	super(new_type)
	if new_type == ControllerType.Joypad:
		wand_tip.text[0] = "You have obtained [i][b]a wand![/b][/i]\nPress [i][b][img width=50 height=50]res://sprites/left_face_button_white.png[/img][/b][/i] to shoot thunderbolts!\nPress [i][b][img width=100 height=50]res://sprites/bumpers.png[/img][/b][/i] to aim!"
	if new_type == ControllerType.Keyboard:
		wand_tip.text[0] = "You have obtained [i][b]a wand![/b][/i]\nPress [i][b]F[/b][/i] to shoot thunderbolts!\nPress [i][b]UP[/b][/i] to aim!"
