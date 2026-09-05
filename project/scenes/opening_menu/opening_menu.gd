extends DefaultScene

var keyboard_tip: Sprite2D
var joypad_tip: Sprite2D
var animation_player: AnimationPlayer
var menu: Sprite2D
var menu_noise: AudioStreamPlayer
var select_noise: AudioStreamPlayer
var selected: int = 0
var menu_selects = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	keyboard_tip = find_child("Keyboard", true)
	joypad_tip = find_child("Joypad", true)
	animation_player = find_child("AnimationPlayer")
	
	menu = find_child("Menu")
	menu_selects = [menu.find_child("Start").find_child("Select"), menu.find_child("Credits").find_child("Select")]
	menu_noise = find_child("MenuNoise")
	select_noise = find_child("SelectNoise")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if menu.visible:
		
		if event.get_action_strength("ui_down") > 0.7:
			if selected == 0:
				menu_selects[selected].hide()
				selected = 1
				menu_selects[selected].show()
				menu_noise.play()
		if event.get_action_strength("ui_up") > 0.7:
			if selected == 1:
				menu_selects[selected].hide()
				selected = 0
				menu_selects[selected].show()
				menu_noise.play()
		if event.is_action("ui_accept"):
			if selected == 0:
				menu.hide()
				select_noise.play()
				emit_signal("play_music", "Somber")
				animation_player.play("Zoom")
	
func _on_controller_type_changed(new_type: ControllerType):
	super(new_type)
	if new_type == ControllerType.Joypad:
		keyboard_tip.hide()
		joypad_tip.show()
	if new_type == ControllerType.Keyboard:
		keyboard_tip.show()
		joypad_tip.hide()
