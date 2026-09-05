extends DefaultScene

const first_score = 50
const second_score = 25

var tip_window: DialogWindow
var cover_animation_player: AnimationPlayer
var girls: Array = []
var girl1st: Girl
var girl2nd: Girl
var girl3rd: Girl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	current_score = 30
	tip_window = dolly.find_child("TipWindow")
	tip_window.next_line.connect(
		func (index: int):
			if index == 3:
				girl3rd.fade_in()
			if index == 4:
				girl2nd.fade_in()
			if index == 6:
				girl1st.fade_in()
	)
	tip_window.done.connect(
		func():
			cover_animation_player.play("EndScene")
	)
	cover_animation_player = dolly.find_child("CoverAnimationPlayer")
	cover_animation_player.animation_finished.connect(
		func (name: String):
			if name == "BeginScene":
				tip_window.start()
			if name == "EndScene":
				emit_signal("next_scene", SceneInfo.from_name("fin"))
	)
	girl1st = dolly.find_child("Girl1st")
	girl2nd = dolly.find_child("Girl2nd")
	girl3rd = dolly.find_child("Girl3rd")
	girls = [girl1st, girl2nd, girl3rd]
	if current_score < second_score:
		girl3rd.set_girl(3)
		girl3rd.points = current_score
		girl1st.set_girl(1)
		girl1st.points = first_score
		girl2nd.set_girl(2)
		girl2nd.points = second_score
	elif current_score < first_score:
		girl3rd.set_girl(2)
		girl3rd.points = second_score
		girl1st.set_girl(1)
		girl1st.points = first_score
		girl2nd.set_girl(3)
		girl2nd.points = current_score
	elif current_score >= first_score:
		girl3rd.set_girl(2)
		girl3rd.points = second_score
		girl1st.set_girl(3)
		girl1st.points = current_score
		girl2nd.set_girl(1)
		girl2nd.points = first_score
		
	tip_window.text[3] = tip_window.text[3].replace("[NAME]", girl3rd.get_girl_name()).replace("[POINTS]", "%d" % girl3rd.points)
	tip_window.text[4] = tip_window.text[4].replace("[NAME]", girl2nd.get_girl_name()).replace("[POINTS]", "%d" %  girl2nd.points)
	tip_window.text[6] = tip_window.text[6].replace("[NAME]", girl1st.get_girl_name()).replace("[POINTS]", "%d" % girl1st.points)
	tip_window.text[7] = tip_window.text[7].replace("[NAME]", girl1st.get_girl_name())
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
