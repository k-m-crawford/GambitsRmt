class_name Targeting
extends Resource

static func on_enemy_leave_chase_area(body, entity):
	if entity.signal_lock(): return
	
	var cur_target = entity.target_entities[entity.target_idx]
	
	entity.target_entities.erase(body)
	
	# the entity that just left was the one we were
	# targeting, find a new target
	if cur_target not in entity.target_entities:
		update_target_entities(entity)
	elif entity.target_entities.size() <= entity.target_idx:
		#in case popping the leaving body 
		entity.target_idx = entity.target_entities.size() - 1


# for LEADER ENTITY, if an enemy enters your engagement area
# while in battle mode, and you aren't already targeting
# an enemy, target this new enemy.
static func on_enemy_enter_chase_area(body, entity):
	if entity.signal_lock(): return
	
	if entity.target_entities.size() == 0:
		entity.target_idx = 0
	
	entity.target_entities.append(body)
	entity.emit_signal("set_target_entities", entity)


# update the possible targets for a given entity based on a heuristic
# TODO: make generic (currently uses chase area + closest only)
# extra params: range, type of targeting for sorting
static func update_target_entities(entity):
	
	# change: chase area overlap ->  whichever ability range
	entity.target_entities = entity.attack_targeting_method.sort_targets(
			entity,
			entity.chase_area.get_overlapping_bodies()
	)
	
	entity.target_idx = 0
	entity.emit_signal("set_target_entities", entity)


static func get_next_target(dir, entity):
	entity.target_idx += dir
	if entity.target_idx >= entity.target_entities.size():
		entity.target_idx = 0
	elif entity.target_idx < 0:
		entity.target_idx = entity.target_entities.size() - 1
	
	entity.emit_signal("set_target_entities", entity)
