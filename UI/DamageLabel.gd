extends Label

var tween

func _ready():
	tween = $Tween

func _execute(amount, _position):
	self.text = str(amount)
	
	tween.interpolate_property(
		self, "position", _position - Vector2(13, 0),
		_position - Vector2(13, 55), 
		1.25, Tween.TRANS_BACK, Tween.EASE_OUT_IN)
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self, "self_modulate", Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		0.75, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	
func _on_Tween_tween_all_completed():
	self.queue_free()
