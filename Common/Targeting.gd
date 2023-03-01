class_name Targeting
extends Resource

static func on_enemy_leave_chase_area(body, entity, signal_lock):
	if signal_lock: return
	
	entity.target_entities.erase(body)
	
	if entity.chase_area.get_overlapping_bodies().size() > 0:
		var new_target = entity.attack_targeting_method.find_targets(
			entity,
			entity.chase_area.get_overlapping_bodies()
		)
		
		print(entity.chase_area.get_overlapping_bodies())
		
		if new_target == entity.target_entities:
			return
		
		entity.target_entities = new_target
		entity.emit_signal("set_target_entities", entity, entity.target_entities)
	
	else:
		entity.emit_signal("set_target_entities", entity, [])
		
static func on_enemy_enter_chase_area(body, entity, signal_lock):
	if signal_lock: return
	
	if entity.target_entities.size() == 0:
		entity.target_entities.append(body)
		entity.emit_signal("set_target_entities", entity, entity.target_entities)
	print(entity.target_entities)


static func update_target_entities(entity):
	
	if entity.target_entities.size() == 0:
		if entity.chase_area.get_overlapping_bodies().size() > 0:
			entity.target_entities = entity.attack_targeting_method.find_targets(
					entity,
					entity.chase_area.get_overlapping_bodies()
				)
			entity.emit_signal("set_target_entities", entity, entity.target_entities)
		else:
			entity.target_entities = []
			entity.emit_signal("set_target_entities", entity, [])

static func get_next_target(dir, entity):
	var targets = entity.chase_area.get_overlapping_bodies()
	
	if targets.size() > 1:
		
		targets = entity.attack_targeting_method.find_targets(
			entity,
			targets,
			true
		)
		
		var i = 0
		
		if entity.target_entities.size() > 0:
			i = targets.find(entity.target_entities[0])
			entity.target_entities.pop_at(0)
		
		i += dir
		if i > targets.size() - 1:
			i = 0
		elif i < 0:
			i = targets.size() - 1
		
		entity.target_entities.append(targets[i])
			
		entity.emit_signal("set_target_entities", entity, entity.target_entities)
