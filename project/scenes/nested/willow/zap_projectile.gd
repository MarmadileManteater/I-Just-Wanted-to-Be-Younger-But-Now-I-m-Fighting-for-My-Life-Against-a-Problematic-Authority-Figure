extends Area2D

class_name ZapProjectile

signal destroy

var is_active: bool = false
var speed: float = 10
var was_on_screen: bool = false

var notifier: VisibleOnScreenNotifier2D
var audio_stream_player: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player = get_child(get_child_count() - 2)
	notifier = get_child(get_child_count() - 1)
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active:
		position.y -= speed
		if notifier.is_on_screen():
			was_on_screen = true
			
		if was_on_screen and not notifier.is_on_screen():
			destroy_self()

func fire() -> void:
	is_active = true
	audio_stream_player.play()
	
func destroy_self() -> void:
	emit_signal("destroy")
	
func _on_body_entered(node: Node2D):
	if is_active:
		if node.has_method("_on_zap_projectile_collide"):
			if node._on_zap_projectile_collide():
				destroy_self()
