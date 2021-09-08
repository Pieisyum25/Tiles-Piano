extends Label


var value setget set_value


func _ready():
	self.value = 0

func set_value(v):
	text = str(v)
	value = v
