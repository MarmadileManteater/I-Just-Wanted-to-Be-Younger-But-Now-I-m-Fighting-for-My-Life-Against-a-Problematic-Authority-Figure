extends DefaultScene

var physics_off_point: Area2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	physics_off_point = find_child("PhysicsOffPoint", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_physics_off_point_body_entered(body: Node2D) -> void:
	if body == willow:
		dolly.unlock()
		
		var awnings = find_children("Awning*")
		for awning in awnings:
			if awning.position.y > physics_off_point.global_position.y:
				remove_child(awning)

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body == willow:
		willow.die()
		hearts.health = 0
