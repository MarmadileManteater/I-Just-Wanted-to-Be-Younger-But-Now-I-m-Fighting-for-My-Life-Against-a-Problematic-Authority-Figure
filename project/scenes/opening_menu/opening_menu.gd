extends DefaultScene

var keyboard_tip: Sprite2D
var joypad_tip: Sprite2D
var animation_player: AnimationPlayer
var menu: Sprite2D
var menu_noise: AudioStreamPlayer
var select_noise: AudioStreamPlayer
var selected: int = 0
var menu_selects = []
var enter_unpressed = false
var difficulty_selects = []
var difficulty_header: Sprite2D
var main_menu: Node2D
var difficulty_menu: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	keyboard_tip = find_child("Keyboard", true)
	joypad_tip = find_child("Joypad", true)
	animation_player = find_child("AnimationPlayer")
	
	menu = find_child("Menu")
	main_menu = menu.find_child("MainMenu")
	difficulty_menu = menu.find_child("DifficultyMenu")
	menu_selects = [main_menu.find_child("Start").find_child("Select"), main_menu.find_child("Credits").find_child("Select")]
	
	difficulty_selects =  [difficulty_menu.find_child("Normal").find_child("Select"), difficulty_menu.find_child("Hard").find_child("Select")]
	
	menu_noise = find_child("MenuNoise")
	select_noise = find_child("SelectNoise")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if menu.visible:
		var selects = []
		if main_menu.visible:
			selects = menu_selects
		if difficulty_menu.visible:
			selects = difficulty_selects
		if event.get_action_strength("ui_down") > 0.7:
			if selected == 0:
				selects[selected].hide()
				selected = 1
				selects[selected].show()
				menu_noise.play()
		if event.get_action_strength("ui_up") > 0.7:
			if selected == 1:
				selects[selected].hide()
				selected = 0
				selects[selected].show()
				menu_noise.play()
		if event.is_action("ui_accept") and enter_unpressed:
			if main_menu.visible:
				if selected == 0:
					main_menu.hide()
					difficulty_menu.show()
					enter_unpressed = false
					select_noise.play()
				if selected == 1:
					emit_signal("next_screen", SceneInfo.from_name("credits"))
			elif difficulty_menu.visible:
				emit_signal("set_difficulty", selected)
				menu.hide()
				select_noise.play()
				animation_player.play("Zoom")
	
func _on_controller_type_changed(new_type: ControllerType):
	super(new_type)
	if new_type == ControllerType.Joypad:
		keyboard_tip.hide()
		joypad_tip.show()
	if new_type == ControllerType.Keyboard:
		keyboard_tip.show()
		joypad_tip.hide()

func _physics_process(delta: float) -> void:
	if not Input.is_action_pressed("ui_accept"):
		enter_unpressed = true

func _on_select_noise_finished() -> void:
	emit_signal("play_music", "Somber")
