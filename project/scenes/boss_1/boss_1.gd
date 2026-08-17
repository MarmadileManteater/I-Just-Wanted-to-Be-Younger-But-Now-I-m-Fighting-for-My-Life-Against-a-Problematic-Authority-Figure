extends DefaultScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	willow.bounce(1.5)
	var timer = Timer.new()
	add_child(timer)
	timer.start(5)
	timer.connect("timeout", func ():
		find_child("SlamAnimationPlayer").play("LeftArmSlam")
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
