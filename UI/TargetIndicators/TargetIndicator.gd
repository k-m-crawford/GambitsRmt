class_name TargetIndicator
extends Line2D

var antagonistic_base = Color(0.82, 0.22, 0.17, 1)
var antagonistic_glow = Color(0.86, 0.34, 0.35, 1)

var friendly_base = Color(0.06, 0.34, 0.77, 1)
var friendly_glow = Color(0.42, 0.76, 0.89, 1)

var cur_point = 0
var recede_point = 0

var kill_fade = false
var kill_sig = false

var tick = 0
var tick_cap = 0.000000000005

var alpha = 1.0

func fade_out(delta):
	alpha -= delta * 5
	self.modulate = Color(1,1,1,alpha)
	if alpha <= 0: queue_free()


func kill(_fade):
	kill_sig = true
	kill_fade = _fade

