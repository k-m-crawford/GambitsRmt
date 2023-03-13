class_name Gambit
extends Resource


enum Target {
	ENEMY,
	ALLY,
	SELF
}

enum Condition {
	MORE_THAN,
	LESS_THAN,
	EQUAL,
	ALWAYS,
	HIGHEST,
	LOWEST,
	CLOSEST,
	FURTHEST,
	ANY
}

enum Trigger {
	HP,
	MP,
	STATUS,
	ATTRIBUTES,
	SELF_HP,
	SELF_MP,
	PROXIMITY
}

@export var gambit_name = ""
@export var target = Target.SELF
@export var trigger = Trigger.HP
@export var trigger_val = 0.0
@export var condition = Condition.LESS_THAN
@export var action:GambitAction


func evaluate_gambit(e) -> BattleEntity:
	print(target, trigger, trigger_val, condition, action)
	e.range_area_shape.shape.radius = action.targeting_range
	var target_pool = e.range_area.get_overlapping_bodies()
	
	match target:
		Target.ALLY:
			target_pool = target_pool.filter(func(e): return e.is_in_group("Allies"))
		Target.ENEMY:
			target_pool = target_pool.filter(func(e): return e.is_in_group("Enemies"))
		Target.SELF:
			target_pool = [e]
			
	if target_pool.size() < 1: return null
	print("still have targets")
	
	var trigger_get_func:Callable
	var trigger_cap_get_func:Callable
	
	match trigger:
		Trigger.HP:
			trigger_get_func = func(e): return e.stats.hp 
			trigger_cap_get_func = func(e): return e.stats.max_hp
		Trigger.MP:
			trigger_get_func = func(e): return e.stats.mp
			trigger_cap_get_func = func(e): return e.stats.max_mp
		Trigger.STATUS:
			trigger_get_func = func(e): return e.stats.status 
	
	match condition:
		Condition.MORE_THAN:
			target_pool = target_pool.filter(func(e): \
					return trigger_get_func.call(e) / trigger_cap_get_func.call(e) > trigger_val
			)
			target_pool = [target_pool.pick_random()]

		Condition.LESS_THAN:
			target_pool = target_pool.filter(func(e): \
					return trigger_get_func.call(e) / trigger_cap_get_func.call(e) < trigger_val
			)
			target_pool = [target_pool.pick_random()]

		Condition.EQUAL:
			#TODO: add status support (status is an array)
			target_pool = target_pool.filter(func(e): \
					return trigger_get_func.call(e) == trigger_val
			)
			target_pool = [target_pool.pick_random()]

		Condition.CLOSEST:
			target_pool.sort_custom(func(a, b): return \
					a.global_position.distance_to(e.global_position) < \
					b.global_position.distance_to(e.global_position)
			)
			target_pool = [target_pool[0]]

		Condition.FURTHEST:
			target_pool.sort_custom(func(a, b): return \
					a.global_position.distance_to(e.global_position) > \
					b.global_position.distance_to(e.global_position)
			)
			target_pool = [target_pool[0]]

		Condition.HIGHEST:
			target_pool.sort_custom(func(a, b): return \
					trigger_get_func.call(a) > \
					trigger_get_func.call(b)
			)
			target_pool = [target_pool[0]]

		Condition.HIGHEST:
			target_pool.sort_custom(func(a, b): return \
					trigger_get_func.call(a) < \
					trigger_get_func.call(b)
			)
			target_pool = [target_pool[0]]

		Condition.ANY:
			target_pool = [target_pool.pick_random()]
	
	if target_pool.size() >= 1: target_pool = target_pool[0]
	else: return null
	
	# TODO add action-specific conditionals here
	# extracted directly from "action" object
	print("got target")
	return target_pool


# evaluate this entity's gambit ladder
static func do_gambit_ladder(e):
	
	var gambit_target = null
	var gambit_action = null
	var g = -1
	
	while not gambit_target and g < e.gambits.size() - 1:
		g += 1
		print("evaluating gambit ", e.gambits[g].gambit_name)
		gambit_target = e.gambits[g].evaluate_gambit(e)
		gambit_action = e.gambits[g].action

	if gambit_target != null:
		e.action_queue = gambit_action
		e.target_entity = gambit_target
	else:
		e.action_queue = null
		e.target_entities = null
	
	e.emit_signal("set_target_entity", e)
