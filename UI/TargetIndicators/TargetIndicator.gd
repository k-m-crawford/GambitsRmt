class_name TargetIndicator
extends Line2D

enum {
	KILL = 1,
	FADE = 2
}

var antagonistic_base = Color(0.82, 0.22, 0.17, 1)
var antagonistic_glow = Color(0.86, 0.34, 0.35, 1)

var friendly_base = Color(0.06, 0.34, 0.77, 1)
var friendly_glow = Color(0.42, 0.76, 0.89, 1)

var cur_point = 0
var recede_point = 0

var kill_sig = 0

var tick: float = 0
var tick_cap = 0.025
var kill_tick = 1
var fade_tick = 1

var alpha = 1.0

func fade_out(delta):
	alpha -= delta
	self.modulate = Color(1,1,1,alpha)
	if alpha <= 0: queue_free()


func kill(flags, immediate=true):
	if immediate: kill_tick = 0
	kill_sig = flags

