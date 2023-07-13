extends Path2D

@export var speed = 80
@export var base_power = 26
@export_enum("PWR", "ATK", "STN") var _base_damage_stat:String # base stat
@export var rand_lower_bound:float
@export var rand_upper_bound:float
@export_enum("STN", "VIT", "MAG", "SPR", "DEF", "MDEF") var _defense_stat:String
@export var mult_base:float
@export_enum("STN", "MAG") var _mult_stat:String
@export_enum("STN", "VIT", "MAG", "SPR", "SPD") var _add_mult_stat:String

@onready var follow = $PathFollow2D
@onready var shadow = $ShadowPath/PathFollow2D/Shadow
@onready var shadow_path = $ShadowPath
@onready var shadow_follow = $ShadowPath/PathFollow2D
@onready var hitbox = $PathFollow2D/Hitbox

var pts:PackedVector2Array = []
var distance = 0
var src_entity:BattleEntity
var base_damage_stat
var defense_stat
var mult_stat
var add_mult_stat

func _ready():
	position = Vector2(0,0)
	
	for pt in pts:
		curve.add_point(pt)
	curve.add_point(distance)

	shadow_path.curve.add_point(Vector2(0, 0))
	shadow_path.curve.add_point(distance)
	
	if src_entity.is_in_group("Enemies"):
		hitbox.set_collision_mask_value(9, true)
	else:
		hitbox.set_collision_mask_value(10, true)

func spawn(src, dest, _dmg_calc):
	src_entity = src
	
	var tween_func
	if src.global_position.y < dest.y:
		tween_func = Callable(self, "ease_in_cubic")
	else:
		tween_func = Callable(self, "ease_out_cubic")
	
	distance = dest - src.global_position
	
	var _pts = 8.0
	for i in range(_pts):
		var t = (1.0 / _pts) * i
		var x = (distance.x / _pts) * i
		var y = tween_func.call(t) * distance.y
		pts.append(Vector2(x,y))
	
	match(_base_damage_stat):
		"PWR": base_damage_stat = base_power
		"STN": base_damage_stat = src.stats.stn
		"ATK": base_damage_stat = src.stats.atk
	match(_mult_stat):
		"STN": mult_stat = src.stats.stn
		"MAG": mult_stat = src.stats.mag
	match(_add_mult_stat):
		"STN": add_mult_stat = src.stats.stn
		"VIT": add_mult_stat = src.stats.vit
		"MAG": add_mult_stat = src.stats.mag
		"SPR": add_mult_stat = src.stats.spr
		"SPD": add_mult_stat = src.stats.spd


func ease_out_cubic(number : float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)


func ease_in_cubic(number: float) -> float:
	return number * number * number


func _process(delta):
	follow.progress = follow.progress + delta * speed
	shadow_follow.progress += delta * speed

	if follow.progress_ratio >= 1:
		queue_free()


func _on_hitbox_body_entered(body):
	
	match(_defense_stat):
		"STN": defense_stat = body.stats.stn
		"VIT": defense_stat = body.stats.vit
		"MAG": defense_stat = body.stats.mag
		"SPR": defense_stat = body.stats.spr
		"DEF": defense_stat = body.stats.def
		"MDEF": defense_stat = body.stats.mdef
	
	var dmg = _b.dmg_calc(base_damage_stat, randf_range(rand_lower_bound, rand_upper_bound),
							defense_stat, mult_base, mult_stat, src_entity.stats.lvl, add_mult_stat)
	EntityMgr.apply_damage(src_entity, body, dmg)
	body.apply_knockback(hitbox)
	queue_free()
