extends Control


onready var score = $Score
onready var black_background = $BlackBackground
onready var game_over_image = $GameOverImage
onready var game_over_sound = $GameOverSound
const game_over_screen_duration = 2


func _ready():
	rect_size = get_viewport_rect().size
	score.get("custom_fonts/font").set_size(rect_size.x/7)
	score.value = 0
	black_background.self_modulate.a = 0.0
	game_over_image.self_modulate.a = 0.0
	game_over_sound.stream.set_loop(false)

func increment_score():
	score.value += 1

func set_color(color):
	score.set("custom_colors/font_color", color)

func game_over_screen():
	$Fade.interpolate_property(black_background, "self_modulate:a", 0.0, 1.0,
		game_over_screen_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Fade.interpolate_property(game_over_image, "self_modulate:a", 0.0, 1.0,
		game_over_screen_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Fade.start()
	game_over_sound.play()
