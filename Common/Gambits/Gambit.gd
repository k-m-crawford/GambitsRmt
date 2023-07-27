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


func evaluate_gambit(e:BattleEntity) -> BattleEntity:
	
	e.range_area.shape.radius = action.targeting_range
	e.range_area.force_shapecast_update()
	
	var target_pool = e.query_targets_in_range()
	
	match target:
		Target.ALLY:
			target_pool = target_pool.filter(func(en): return en.is_in_group("Allies"))
		Target.ENEMY:
			target_pool = target_pool.filter(func(en): return en.is_in_group("Enemies"))
		Target.SELF:
			target_pool = [e]
	_b.debug(target_pool, e)
	if target_pool.size() < 1: return null
	
	var trigger_get_func:Callable
	var trigger_cap_get_func:Callable
	
	match trigger:
		Trigger.HP:
			trigger_get_func = func(e): return float(e.stats.hp)
			trigger_cap_get_func = func(e): return float(e.stats.max_hp)
		Trigger.MP:
			trigger_get_func = func(e): return e.stats.mp
			trigger_cap_get_func = func(e): return e.stats.max_mp
		Trigger.STATUS:
			trigger_get_func = func(e): return e.stats.status 
	
	match condition:
		Condition.MORE_THAN:
			target_pool = target_pool.filter(func(e): 
					return trigger_get_func.call(e) / trigger_cap_get_func.call(e) > trigger_val
			)
			if target_pool.size() > 0: target_pool = [target_pool.pick_random()]

		Condition.LESS_THAN:
			_b.debug("target pool before " + str(target_pool), e)
			target_pool = target_pool.filter(func(e): 
					return trigger_get_func.call(e) / trigger_cap_get_func.call(e) < trigger_val 
			)
			_b.debug("target pool after cond " + str(target_pool), e)
			if target_pool.size() > 0: target_pool = [target_pool.pick_random()]

		Condition.EQUAL:
			#TODO: add status support (status is an array)
			target_pool = target_pool.filter(func(e): 
					return trigger_get_func.call(e) == trigger_val
			)
			if target_pool.size() > 0: target_pool = [target_pool.pick_random()]

		Condition.CLOSEST:
			target_pool.sort_custom(func(a, b): return \
					a.global_position.distance_to(e.global_position) < \
					b.global_position.distance_to(e.global_position)
			)
			if target_pool.size() > 0: target_pool = [target_pool[0]]

		Condition.FURTHEST:
			target_pool.sort_custom(func(a, b): return \
					a.global_position.distance_to(e.global_position) > \
					b.global_position.distance_to(e.global_position)
			)
			if target_pool.size() > 0: target_pool = [target_pool[0]]

		Condition.HIGHEST:
			target_pool.sort_custom(func(a, b): return \
					trigger_get_func.call(a) > \
					trigger_get_func.call(b)
			)
			if target_pool.size() > 0: target_pool = [target_pool[0]]

		Condition.LOWEST:
			target_pool.sort_custom(func(a, b): return \
					trigger_get_func.call(a) < \
					trigger_get_func.call(b)
			)
			if target_pool.size() > 0: target_pool = [target_pool[0]]

		Condition.ANY:
			if target_pool.size() > 0: target_pool = [target_pool.pick_random()]
	
	if target_pool.size() >= 1: target_pool = target_pool[0]
	else: return null
	
	# TODO add action-specific conditionals here
	# extracted directly from "action" object
	
	return target_pool


# evaluate this entity's gambit ladder
static func do_gambit_ladder(e) -> bool:
	var gambit_target = null
	var gambit_action = null
	
#	while not gambit_target and g < e.gambits.size() - 1:
	gambit_target = e.gambits[e.cur_gambit].evaluate_gambit(e)
	gambit_action = e.gambits[e.cur_gambit].action

	if gambit_target != null:
		e.prev_target = e.target_entity
		e.target_entity = gambit_target
		gambit_action.enqueue(e)
		e.reset_gambit_ladder()
		e.emit_signal("to_Manager_set_target_entity", e)
		return true
	else:
		e.action_queue = []
		e.target_entity = null
		e.target_entities = null
		e.increment_gambit_ladder()
		return false



# get next manual target within range of e given entity
static func get_next_target(e:BattleEntity, group:String, dir=0):
	
	# TODO: add default "weapon" ranges
	var target_pool = e.query_targets_in_range()
	
	target_pool = target_pool.filter(func(e): return e.is_in_group(group))

	target_pool.sort_custom(func(a, b): return \
			a.global_position.distance_to(e.global_position) < \
			b.global_position.distance_to(e.global_position)
	)
	
	if target_pool.size() < 1: return null
	
	var i = 0
	if e.target_entity != null:
		print(target_pool.find(e.target_entity), "+", dir)
		i = target_pool.find(e.target_entity) + dir
		print(i)
		
		if i < 0: i = target_pool.size() - 1
		if i >= target_pool.size(): i = 0
	
	print(e.target_entity, target_pool[i])
	return target_pool[i]
