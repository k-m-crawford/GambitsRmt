extends GambitAction

var i_rock = preload("res://Projectile.tscn")


func _charge_func(e:BattleEntity):
	print("READY THROW")
	e.anim_container.set_anim("ReadyThrow", true)


func _execute(e:BattleEntity, _delta):
	print("here")
	e.anim_container.set_anim("PerformThrow", true)
	var rock = i_rock.instantiate()
	e.add_child(rock)
	rock.spawn(e, aux["TargetInitialPosition"])
	e.action_queue.pop_front()
