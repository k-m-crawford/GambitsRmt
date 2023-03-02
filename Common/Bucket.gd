class_name _b
extends Node

func _ready():
	randomize()


static func debug(msg, obj):
	if obj.debug:
		print(msg)
