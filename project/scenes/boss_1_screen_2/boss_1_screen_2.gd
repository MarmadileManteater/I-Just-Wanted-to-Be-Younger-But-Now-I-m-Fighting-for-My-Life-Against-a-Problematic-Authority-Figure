extends DefaultScene

var boss_feet: BossFeet

func _ready() -> void:
	super()
	boss_feet = find_child("BossFeet")
	
	boss_feet.leftie.connect("crush", _on_crush)
	boss_feet.rightie.connect("crush", _on_crush)
	boss_feet.animation_player.play("Stomp")

func _on_crush():
	hearts.health = 0
	willow.die("crushed")
