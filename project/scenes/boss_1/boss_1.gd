extends DefaultScene

@export var player_threshold: int = 10

var boss_top: Node2D
var boss_bottom: Node2D

var slam_animation_player: AnimationPlayer
var bob_animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	boss_top = find_child("BossTop")
	boss_bottom = find_child("BossBottom")
	
	slam_animation_player = find_child("SlamAnimationPlayer")
	bob_animation_player = find_child("BobbingAnimationPlayer")
	
	willow.bounce(1.5)
	var timer = Timer.new()
	add_child(timer)
	timer.start(5)
	timer.connect("timeout", func ():
		find_child("SlamAnimationPlayer").play("LeftArmSlam")
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# left arm logic
	if willow.global_position.x + player_threshold < boss_top.global_position.x:
		if bob_animation_player.current_animation != "Bob":
			bob_animation_player.play("Bob")
		boss_top.position.x -= 2
		boss_bottom.position.x -= 2
	elif willow.global_position.x - player_threshold > boss_top.global_position.x:
		if bob_animation_player.current_animation != "Bob":
			bob_animation_player.play("Bob")
		boss_top.position.x += 2
		boss_bottom.position.x += 2
	else:
		bob_animation_player.pause()

func _on_crushed() -> void:
	hearts.health = 0
	willow.die("crushed")
