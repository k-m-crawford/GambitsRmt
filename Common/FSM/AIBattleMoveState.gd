class_name AIBattleMoveState
extends State


func enter(_msg := {}) -> void:
	entity.anim_container.set_textures("BattleEngagedMove")
	entity.anim_container.set_anim("BattleIdle")


#func exit() -> void:
#	entity.action_queue = null


func physics_update(delta) -> void:
	if not entity._FSM.check_flag("BATTLE_ENGAGED"):
		entity._FSM.transition_to("BATTLE_ENGAGE")
		return
	if entity.stun_tick > 0:
		entity.stun_tick -= delta
		entity.move_nav_agent(entity.target_entity.global_position, delta)
		entity.anim_container.set_anim("Move")
	# if no action queue
	# do gambit ladder
	elif entity.action_queue.size() > 0:
		entity.action_queue[0]._while_queued(entity, delta)
	
	else:
		
		# no gambit successful
		if !Gambit.do_gambit_ladder(entity):
			# find enemy to chase, if none, exit battle 
			var hits = entity.chase_area.get_overlapping_areas()
			if hits.size() > 0:
				hits.sort_custom(func(a, b): 
					return a.get_parent().global_position.distance_to(entity.global_position) \
					< b.get_parent().global_position.distance_to(entity.global_position)
				)
				entity.move_nav_agent(hits[0].get_parent().global_position, delta)
				entity.anim_container.set_anim("Move")
			else:
				entity._FSM.set_flag("BATTLE_ENGAGED")
	
