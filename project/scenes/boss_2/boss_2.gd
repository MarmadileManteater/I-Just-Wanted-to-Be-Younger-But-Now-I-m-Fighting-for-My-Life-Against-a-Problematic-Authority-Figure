extends DefaultScene

const projectile_seed: Resource = preload("res://scenes/boss_2/letter_projectile.tscn")

var projectile_start: Node2D
var glasses: AnimatedSprite2D
var glasses_animation_player: AnimationPlayer

var current_word: String = ""

var health: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	projectile_start = find_child("ProjectileStart")
	glasses = find_child("Glasses")
	glasses_animation_player = glasses.find_child("AnimationPlayer")
	fire_word("TESSSSTTTTT", 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire_word(word: String, rate: float):
	current_word = word
	var timer = Timer.new()
	timer.timeout.connect(
		func ():
			var letter = current_word[0]
			fire(letter)
			current_word = current_word.substr(1)
	)
	add_child(timer)
	timer.start(rate)

func fire(letter: String):
	var parent = get_parent()
	var letter_projectile: LetterProjectile = projectile_seed.instantiate()
	letter_projectile.position = projectile_start.position
	letter_projectile.direction = (willow.position - letter_projectile.position).normalized()
	letter_projectile.destroy.connect(
		func ():
			parent.remove_child(letter_projectile)
			letter_projectile.queue_free()
	)
	letter_projectile.collide.connect(
		func(): 
			if hearts.health > 1:
				hearts.health -= 1
				willow.hurt()
				willow.flash()
			else:
				hearts.health = 0
				die("disintegrate")
				
			parent.remove_child(letter_projectile)
			letter_projectile.queue_free()
	)
	parent.add_child(letter_projectile)
	letter_projectile.set_letter(letter)

func _on_glasses_damage() -> void:
	health -= 1
	glasses.play("%d" % floor((100 - health) / 15))
		
	glasses_animation_player.play("Bob")
