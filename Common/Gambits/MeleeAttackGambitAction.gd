class_name MeleeAttackGambitAction
extends GambitAction


func _while_queued(e:BattleEntity, delta):
	if first_pass:
		var hits = e.hitbox.get_overlapping_areas()
		if e.target_entity.hurtbox in hits:
			e.anim_container.set_anim("Attack")
			for h in hits:
				var hit = h.get_parent()
				var dmg = _b.dmg_calc(e.stats.atk, randf_range(1, 1.125), hit.stats.def,
										1, e.stats.stn, e.stats.lvl, e.stats.stn)
				EntityMgr.apply_damage(hit, dmg)
		#			hit.apply_knockback(e)
			first_pass = false
			await e.anim_container.anim.animation_finished
			e.stun_tick = randf_range(0.6, 1.0)
			e.action_queue.pop_front()
		
		else:
			e.move_nav_agent(e.target_entity.global_position, delta)
			e.anim_container.set_anim("BattleMove")
