extends Area2D

class_name ZapProjectile

var is_active: bool = false
var speed: float = 10
var notifier: VisibleOnScreenNotifier2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	notifier = find_child("VisibleOnScreenNotifier2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active:
		position.y -= speed
		
		#if not notifier.is_on_screen():
			#get_parent().remove_child(self)
			#self.queue_free()

func fire() -> void:
	is_active = true
	
