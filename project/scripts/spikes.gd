extends Area2D

signal damage

@export var character_name = "Willow"
@export var sharpness: int = 1

var damage_interval: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func emit_damage():
	emit_signal("damage", sharpness)

func _on_body_entered(node: Node2D) -> void:
	if node.name == character_name:
		emit_damage()
		damage_interval = Timer.new()
		add_child(damage_interval)
		damage_interval.connect("timeout", emit_damage)
		damage_interval.start(0.1)
		
func _on_body_exited(node: Node2D) -> void:
	if node.name == character_name:
		damage_interval.stop()
		damage_interval.free()
		damage_interval = null
