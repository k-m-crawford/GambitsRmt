extends Camera2D

var speed = 3
var following
var zoom_tracking = []
var zoom_margin = 25

func _ready():
	EntityMgr.hook_camera(self)

func follow_entity(entity):
#	for e in following:
#		if e.visibility_node.screen_exited.is_connected(exited_screen):
#			e.visibility_node.screen_exited.disconnect(exited_screen)
#		if e.visibility_node.screen_entered.is_connected(entered_screen):
#			e.visibility_node.screen_entered.disconnect(entered_screen)
#
	following = entity
#
#	for e in following:
#		e.visibility_node.screen_exited.connect(exited_screen.bind(e))
#		e.visibility_node.screen_entered.connect(entered_screen.bind(e))


func _physics_process(delta):
	if !following: return
#		if e.global_position.x < (global_position.x + zoom_margin) or \
#					e.global_position.x > (global_position.x + global_transform.x.x) or \
#					e.global_position.y < (global_position.y + zoom_margin) or \
#					e.global_position.y > (global_position.y + global_transform.y.y):
#			zoom_tracking.append(e)
#		else:
#			zoom_tracking.erase(e)
	
	set_global_position(
		lerp(
			get_global_position().round(), 
			following.get_global_position().round(), 
			delta*speed
		)
	)
	global_position = global_position.round()
#
#	if zoom_tracking:
#		set_zoom(
#			lerp(
#				zoom,
#				zoom*0.9,
#				delta*speed
#			)
#		)
#	elif zoom < Vector2.ONE:
#		set_zoom(
#			lerp(
#				zoom,
#				zoom*1.1,
#				delta*speed
#			)
#		)
#		if zoom > Vector2.ONE:
#			set_zoom(Vector2.ONE)

#
#func exited_screen(e):
#	zoom_tracking.append(e)
#
#
#func entered_screen(e):
#	if e in zoom_tracking:
#		zoom_tracking.erase(e)
