extends State

var wander_target

var timer:Timer
export var wait_time_min = 3
export var wait_time_max = 3

func initialize(_msg := {}) -> void:
	wander_target = entity.global_position
	

func enter(_msg := {}) -> void:
	timer = Timer.new()
	entity._FSM.add_child(timer)
	timer.wait_time = randi() % wait_time_max - 1 + wait_time_min
	# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "start_wander")
	timer.one_shot = true
	timer.start()



func start_wander():
	print("wander start")
	wander_target =  entity.global_position + Vector2(
			randi()%300 - 150, 
			randi()%300 - 150
	)
	entity.nav_agent.set_target_location(wander_target)
	timer.wait_time = randi() % wait_time_max - 1 + wait_time_min




func physics_update(delta) ->  void:
	if entity.engagement_area.get_overlapping_bodies().size() > 0:
		entity._FSM.transition_to("BATTLE_ENGAGE", {"ENTER":null})
		return
	if timer.is_stopped():
		# stop walking if you're in a reasonable distance
		if entity.nav_agent.is_navigation_finished():
#			
			if entity.velocity == Vector2.ZERO:
				entity.anim_container.set_anim("Idle", "Default")
				timer.start()
			else:
				entity.slow_to_stop(delta)
				
		else:
			entity.move_nav_agent(
				wander_target, 
				delta, 
				entity.stats.max_walk_speed
			)
			entity.anim_container.set_anim("Walk", "Default")
		

func _exit():
	timer.queue_free()
