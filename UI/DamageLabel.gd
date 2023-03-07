extends Label

@export var debug = false

var tween


func _ready():
	tween = create_tween()
	tween.stop()
	
	if debug:
		_execute(9999, Vector2(250, 150))

func _execute(amount, _position):
	self.text = str(amount)
	self.position = _position - Vector2(13, 0)
	
	tween.tween_property(
		self, "position",
		_position - Vector2(4, 55), 0.75) \
		.from(_position - Vector2(4, 0)) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT_IN)
# warning-ignore:return_value_discarded
	tween.parallel().tween_property(
		self, "self_modulate", Color(1, 1, 1, 0), 1) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN_OUT)
	tween.play()

	tween.tween_callback(func(): self.queue_free())
