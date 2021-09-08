extends Node2D

onready var tile_scene = load("res://Scenes/Tile.tscn")
onready var tiles = $Tiles
onready var move_tween = $Move
onready var screen_size = get_viewport_rect().size


const keys = 4
const queue_max_size = keys*2
var tile_queue = []
var tile_size
var hue = 0.00
const slide_duration = 0.3

var game_over = false
var can_reset = false


func _ready():
	randomize()
	
	var tile_width = screen_size.x / keys
	var tile_height = 2 * tile_width
	tile_size = Vector2(tile_width, tile_height)
	
	$Background.set_color(Color.from_hsv(hue, 1.0, 1.0))
	$GUI.set_color(Color.from_hsv(hue, 1.0, 1.0))
	
	create_all_tiles()

# Creates all tiles within tile_queue:
func create_all_tiles():
	for i in queue_max_size:
		push_tile()

# Creates tile and pushes it to the end of tile_queue:
func push_tile():
	var index = tile_queue.size()
	var key = randi() % keys
	var x = key * tile_size.x
	var y = screen_size.y - (tile_size.y * (index+1))
	var tile = tile_scene.instance()
	tiles.add_child(tile)
	tile.init(key, tile_size)
	tile.position = Vector2(x, y)
	tile.scale = Vector2.ONE * (tile_size.x / tile.texture.get_size().x)
	tile.self_modulate = Color.from_hsv(hue, 1.0, 1.0)
	tile_queue.append(tile)
	
	hue = wrapf(hue+0.01, 0.00, 1.00) # update hue for next tile

# Pops tile from the start of tile_queue and deletes it before shifting all other tiles down:
func pop_tile():
	# Pop bottom tile from queue, update colors to match it, and play its sound/animation:
	var first_tile = tile_queue.pop_front()
	$Background.set_color(first_tile.self_modulate)
	$GUI.set_color(first_tile.self_modulate)
	first_tile.play()
	
	
	# Slide remaining tiles down:
	for i in tile_queue.size():
		var tile = tile_queue[i]
		var end_y = screen_size.y - (tile_size.y * (i+1))
		move_tween.interpolate_property(tile, "position:y", tile.position.y, end_y, 
			slide_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	move_tween.start()

func on_tap(key):
	# If tapped the right tile:
	if key == tile_queue[0].key:
		$GUI.increment_score()
		pop_tile()
		push_tile()
	# Else tapped wrong tile:
	else:
		game_over = true
		$GUI.game_over_screen()
		$ResetTimer.start()

func _unhandled_input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		if not game_over:
			var pos = event.position
			#if pos.y < screen_size.y - (tile_size.x * 2): return
			var key = int(pos.x / tile_size.x)
			on_tap(key)
		elif can_reset:
			get_tree().reload_current_scene()
	elif event is InputEventKey and event.is_pressed():
		if not game_over:
			match event.scancode:
				KEY_1:
					on_tap(0)
				KEY_2:
					on_tap(1)
				KEY_3:
					on_tap(2)
				KEY_4:
					on_tap(3)
		elif can_reset:
			if event.scancode == KEY_R:
				get_tree().reload_current_scene()


func _on_ResetTimer_timeout():
	can_reset = true
	var score_label = $GUI/Score
	#score_label.text += "\nPress\nR\nto\nReset"
