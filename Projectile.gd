extends Path2D

@export var speed = 80

@onready var follow = $PathFollow2D
@onready var shadow = $ShadowPath/PathFollow2D/Shadow
@onready var shadow_path = $ShadowPath
@onready var shadow_follow = $ShadowPath/PathFollow2D

func _ready():
	position = Vector2(0,0)


func spawn(src, dest):
	
	curve.clear_points()
	shadow_path.curve.clear_points()
	
	var tween_func
	if src.global_position.y < dest.y:
#		show_behind_parent = false
		tween_func = Callable(self, "ease_in_cubic")
	else:
#		show_behind_parent = true
		tween_func = Callable(self, "ease_out_cubic")
	
	var distance = dest - src.global_position
	
	var pts = 8.0
	for i in range(pts):
		var t = (1.0 / pts) * i
		var x = (distance.x / pts) * i
		var y = tween_func.call(t) * distance.y
		print(x," ",y)
		curve.add_point(Vector2(x, y))
	curve.add_point(distance)
	
	shadow_path.curve.add_point(Vector2(0, 0))
	shadow_path.curve.add_point(distance)


func ease_out_cubic(number : float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)


func ease_in_cubic(number: float) -> float:
	return number * number * number


func _process(delta):
	follow.progress = follow.progress + delta * speed
	shadow_follow.progress += delta * speed

	if follow.progress_ratio >= 1:
		print("DESTROY")
		queue_free()
