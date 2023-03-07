class_name TargetIndicatorCurve
extends TargetIndicator

@onready var pulse_line = $PulseLine

### entities 
var target
var source

### settings & switches
var persist = false

### animation
var line_pulse_start  = false
var wait = false
var tick_cap_glow = 0.05
var kill_refresh = 0.05


func setup(_source, _target, _clr, _persist):
	kill_tick = 1.5
	
	source = _source
	target = _target
	persist = _persist
	source.add_child(self)
	
	
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
		tween_func = Callable(self, "ease_in_cubic")
	else:
#		show_behind_parent = true
		tween_func = Callable(self, "ease_out_cubic")
		
	var start = Vector2(0, 0)
	var end = target.global_position - global_position
	var _points := []
	var pts = 8.0
	var distance = (end - start)
	
	for i in range(pts):
		var t = (1.0 / pts) * i
		var x = start.x + (distance.x / pts) * i
		var y = start.y + tween_func.call(t) * distance.y
		_points.append(Vector2(x, y))
	_points.append(end)

	return _points


func ease_out_cubic(number : float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)


func ease_in_cubic(number: float) -> float:
	return number * number * number


func _process(delta):
	# recalculate based on start/end at this frame
	var _points = calculate()
	
	if recede_point > cur_point:
		cur_point = recede_point + 1
	
	# the line is still appearing
	if not line_pulse_start:
		self.points = _points.slice(recede_point, cur_point)
	# line appeared
	else:
		self.points = _points.slice(recede_point, _points.size())
		pulse_line.points = _points.slice(recede_point, cur_point)

	var _tick_cap = tick_cap_glow if line_pulse_start else tick_cap
	
	if fade_tick < 0:
		fade_out(delta)
	
	# update only after tick (x) seconds have passed
	if kill_sig and KILL:
		kill_tick -= delta
		if kill_sig and FADE:
			fade_tick -= delta
	
	if tick < _tick_cap:
		tick += delta
	
	if kill_tick <= 0:
		recede_point += 1
		kill_tick = kill_refresh
		if recede_point > points.size():
			queue_free()
	
	if _tick_cap <= tick:
		cur_point += 1
		# check if done drawing
		if cur_point > _points.size():
			if kill_sig:
				pass
			elif not persist:
				line_pulse_start = true
				kill(KILL, false)
			else:
				line_pulse_start = true
		
			cur_point = 0
				
		tick = 0

