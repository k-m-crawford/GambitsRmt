class_name TargetIndicatorCircle
extends TargetIndicator

onready var glow_circle = $GlowCircle
onready var tween = $Tween

var follow_entity:Entity
var appearing = true
var _points
var color_scheme 

func _ready():
	_points = self.points
	glow_circle.points = PoolVector2Array([])
	self.default_color = friendly_base
	glow_circle.default_color = friendly_glow
	visible = false

func setup(pos, _scale, _color_scheme):
	self.position = pos
	self.scale = _scale
	
	match color_scheme:
		"Friendly":
			self.default_color = friendly_base
			glow_circle.default_color = friendly_glow
		"Antagonistic":
			self.default_color = antagonistic_base
			glow_circle.default_color = antagonistic_glow
	
	tick = 0
	self.points = PoolVector2Array([])
	glow_circle.points = PoolVector2Array([])
	appearing = true
	cur_point = 0
	recede_point = 0
	self.visible = true
	
	
func _process(delta):
	
	if kill_fade:
		fade_out(delta)
		
	elif not appearing:
		if tick < tick_cap:
			tick += delta
		else:
			glow_circle.points = PoolVector2Array(
					Array(_points).slice(recede_point, cur_point)
				)
			
			if cur_point < _points.size():
				cur_point += 1
			recede_point += 1
			
			if recede_point > _points.size() - 3:
				cur_point = 4
				recede_point = 0
			
			tick = 0
		
	elif cur_point < _points.size():
		if tick < tick_cap:
			tick += delta
		else:
			self.points = PoolVector2Array(Array(_points).slice(0, cur_point))
			cur_point += 1
			tick = 0
	else:
		appearing = false
		tick = 0
		cur_point = 4
#
	if not follow_entity: return

	move(follow_entity.global_position)
	tween.start()

func move(dest):
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self, "global_position", self.global_position, 
		dest, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
# warning-ignore:return_value_discarded
	tween.start()
	yield(tween, "tween_completed")

func set_follow(to_entity):
	follow_entity = to_entity 
