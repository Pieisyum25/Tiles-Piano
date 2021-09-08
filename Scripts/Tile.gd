extends Sprite


var key # which position along the x this tile is (4 keys in normal piano tiles)
var note # audiostream node to play
var tile_size
const delete_duration = 0.5

# Initialise tile with a specified note sound file:
func init(key, tile_size):
	self.key = key
	self.tile_size = tile_size
	var notes = $Notes.get_children()
	var note_index = randi() % notes.size()
	note = notes[note_index]
	if randi() % 1000 == 0: note = $Bruh
	note.stream.set_loop(false)
	note.connect("finished", self, "_on_note_finished")


# Play deletion animation and note sound:
func play():
	$Delete.interpolate_property(self, "self_modulate:a", 1.0, 0.0,
		delete_duration, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Delete.interpolate_property(self, "scale", scale, scale*1.5,
		delete_duration, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Delete.interpolate_property(self, "position", position, position - (tile_size*1.5 - tile_size)/2,
		delete_duration, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Delete.start()
	note.play()

# Delete tile upon sound ending:
func _on_note_finished():
	queue_free()
