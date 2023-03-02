extends Camera2D

export var zoom_margin = 25

var following = []
var zoom_target = Vector2(1, 1)

func follow_entities(entities):
#	print(entities)
	following = entities

func _process(_delta):
	if following == []: return
	
	var vector = Vector2.ZERO
	var num = 0
	
	for e in following:
		vector += e.global_position
		num += 1
	
	vector = vector / num
	global_position = vector
	
