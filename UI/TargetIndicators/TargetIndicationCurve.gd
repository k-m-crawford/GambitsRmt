class_name TargetIndicationCurve
extends TargetIndicator

onready var pulse_line = $PulseLine

### entities 
var target
var source

### settings & switches
var persist = false

### animation
var line_pulse_start  = false
var wait = false

func setup(_source, _target, _clr, _persist):
	source = _source
	target = _target
	persist = _persist
	source.add_child(self)
	calculate()
	
	match _clr:
		"Friendly":
			self.default_color = friendly_base
			pulse_line.default_color = friendly_glow
		"Antagonistic":
			self.default_color = antagonistic_base
			pulse_line.default_color = antagonistic_glow

func calculate():
	
	var tween_func
	
	if source.global_position.y < target.global_position.y:
#		show_behind_parent = false
		tween_func = funcref(self, "ease_in_cubic")
	else:
#		show_behind_parent = true
		tween_func = funcref(self, "ease_out_cubic")
	
	var start = Vector2(0, 0)
	var end = target.global_position - global_position
	var points := []
	var pts = 8.0
	var distance = (end - start)
	for i in range(pts):
		var t = (1.0 / pts) * i
		var x = start.x + (distance.x / pts) * i
		var y = start.y + tween_func.call_func(t) * distance.y
		points.append(Vector2(x, y))
	points.append(end)
	
	return points
		
func ease_out_cubic(number : float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)

func ease_in_cubic(number: float) -> float:
	return number * number * number

func _process(delta):
	var points = calculate()
	
	if tick < tick_cap:
		tick += delta
	elif not kill_fade:
		# animate
		if not line_pulse_start:
			self.points = points.slice(recede_point, cur_point)
		else:
			self.points = points.slice(recede_point, points.size())
			pulse_line.points = points.slice(recede_point, cur_point)
		
		if kill_sig:
			recede_point += 1
			if recede_point > points.size():
				queue_free()
		else:
			cur_point += 1
			if cur_point > points.size():
				if not persist:
					kill_sig = true
				else:
					line_pulse_start = true
					cur_point = 0
					
		tick = 0
	else:
		fade_out(delta)

