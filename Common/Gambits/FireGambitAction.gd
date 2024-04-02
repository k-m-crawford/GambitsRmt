class_name FireGambitAction
extends GambitAction

var i_fire_anim = preload("res://Animations/EffectAnimations/FireAnimation.tscn")

func _execute(e:BattleEntity, _delta):
	var fire_anim = i_fire_anim.instantiate()
	fire_anim.global_position = e.target_entity.get_global_position()
	var anim_player = fire_anim.get_node("AnimationPlayer")
	EntityMgr.emit_signal("spawn_effect", fire_anim)
	anim_player.animation_finished.connect(destroy.bind(e, fire_anim))
	anim_player.play("1")
	var dmg = _b.dmg_calc(26, randf_range(1, 1.125), e.target_entity.stats.mdef,
							1, e.stats.mag, e.stats.lvl, e.stats.mag)
	EntityMgr.apply_damage(e.target_entity, dmg)
	e.target_entity.apply_knockback(null)
	e.stun_tick = randf_range(0.6, 1)
	e.action_queue.pop_front()


func destroy(_anim, _e, anim_obj):
	anim_obj.queue_free()
