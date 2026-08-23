extends DefaultScene

var keyboard_tip: Sprite2D
var joypad_tip: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	keyboard_tip = find_child("Keyboard", true)
	joypad_tip = find_child("Joypad", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_controller_type_changed(new_type: ControllerType):
	super(new_type)
	if new_type == ControllerType.Joypad:
		keyboard_tip.hide()
		joypad_tip.show()
	if new_type == ControllerType.Keyboard:
		keyboard_tip.show()
		joypad_tip.hide()
