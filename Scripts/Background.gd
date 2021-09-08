extends TextureRect


func _ready():
	rect_size = get_viewport_rect().size

func set_color(color):
	self_modulate = color
