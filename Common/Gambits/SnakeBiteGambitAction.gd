class_name SnakeBiteGambitAction
extends GambitAction

var i_bio_anim = preload("res://Animations/EffectAnimations/BioAnimation.tscn")

	
func _execute(e:BattleEntity, delta):
	if first_pass:
		var hits = e.hitbox.get_overlapping_areas()
		if e.target_entity.hurtbox in hits:
			e.anim_container.set_anim("Attack")
			
			first_pass = false
			await e.anim_container.anim.animation_finished
			hits = e.hitbox.get_overlapping_areas()
			for h in hits:
				var hit = h.get_parent()
				var dmg = _b.dmg_calc(e.stats.atk, randf_range(1, 1.125), hit.stats.def,
										1, e.stats.stn, e.stats.lvl, e.stats.stn)
				EntityMgr.apply_damage(hit, dmg)
				hit.apply_knockback(e.global_position)
				var bio_anim = i_bio_anim.instantiate()
				var anim_player = bio_anim.get_node("AnimationPlayer")
				hit.add_child(bio_anim)
				bio_anim.global_position = hit.get_global_position()
				anim_player.animation_finished.connect(destroy.bind(e, bio_anim))
				anim_player.play("1")
			e.stun_tick = randf_range(1.2, 1.8)
			e.action_queue.pop_front()
		
		else:
			if e.global_position.distance_to(e.target_entity.global_position) \
				> e.chase_area_shape.shape.radius:
					e._FSM.set_flag("BATTLE_ENGAGED")
			else:
				e.move_nav_agent(e.target_entity.global_position, delta)
				e.anim_container.set_anim("BattleMove")


func destroy(_anim, _e, anim_obj):
	anim_obj.queue_free()
