extends Node
class_name Gambit

var target
var trigger
var trigger_val
var action
var more_than

func _init(_action, _target, _trigger, _more_than="LESS_THAN", _trigger_val=0):
	target = _target
	trigger = _trigger
	trigger_val = _trigger_val
	more_than = _more_than
