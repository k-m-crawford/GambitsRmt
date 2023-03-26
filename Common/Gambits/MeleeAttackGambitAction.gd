class_name MeleeAttackGambitAction
extends GambitAction


func _while_queued(e:BattleEntity, delta):
	
	var hits = e.hitbox.get_overlapping_areas()
#	print(hits, "    ", e.target_entity.hurtbox)
	
	if e.target_entity.hurtbox in hits:
		if e.stun_tick <= 0:
			e._FSM.transition_to("ATTACK")
	
	else:
		e.move_nav_agent(e.target_entity.global_position, delta, e.stats.max_walk_speed)
		
