extends GambitAction

var i_rock = preload("res://RockProjectile.tscn")


func _charge_func(e:BattleEntity):
	e.anim_container.set_anim("ReadyThrow", true)


func _execute(e:BattleEntity, _delta):
	if first_pass:
		e.anim_container.set_anim("PerformThrow", true)
		var rock = i_rock.instantiate()
		rock.spawn(e, aux["TargetInitialPosition"], Callable(self, "dmg_func"))
		EntityMgr.emit_signal("spawn_projectile", rock)
		first_pass = false
	
	await e.anim_container.anim.animation_finished
	e.stun_tick = randf_range(0.6, 1.0)
	first_pass = true
	e.action_queue.pop_front()
