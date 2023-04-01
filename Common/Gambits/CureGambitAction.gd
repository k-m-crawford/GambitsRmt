class_name CureGambitAction
extends GambitAction


func _while_queued(e:BattleEntity, delta):
	
	var hits = e.range_area_shape.get_overlapping_areas()
	
	if e.target_entity.hurtbox in hits:
		if e.stun_tick <= 0:
			pass
	
	else:
		e.move_nav_agent(e.target_entity.global_position, delta, e.stats.max_walk_speed)
		e.anim_container.set_anim("BattleMove")
