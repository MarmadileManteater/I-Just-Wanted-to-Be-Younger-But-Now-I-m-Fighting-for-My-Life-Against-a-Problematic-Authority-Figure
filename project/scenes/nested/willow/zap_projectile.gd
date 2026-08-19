extends Area2D

class_name ZapProjectile

signal destroy

var is_active: bool = false
var speed: float = 10
var notifier: VisibleOnScreenNotifier2D
var was_on_screen: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	notifier = get_child(get_child_count() - 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active:
		position.y -= speed
		if notifier.is_on_screen():
			was_on_screen = true
			
		if was_on_screen and not notifier.is_on_screen():
			emit_signal("destroy")
			get_parent().remove_child(self)
			self.queue_free()

func fire() -> void:
	is_active = true
	
