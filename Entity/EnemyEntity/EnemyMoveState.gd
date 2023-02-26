extends State

var wander_target

var timer:Timer
export var wait_time_min = 2
export var wait_time_max = 2

func initialize(_msg := {}) -> void:
	wander_target = entity.position
	

func enter(_msg := {}) -> void:
	timer = Timer.new()
	entity._FSM.add_child(timer)
	timer.wait_time = randi() % wait_time_max - 1 + wait_time_min
	# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "start_wander")
	timer.start()
	
	entity.anim_container.set_textures("Move")
	
func start_wander():
#	print("start wander")
	timer.stop()
	wander_target =  entity.position + Vector2(
			randi()%150 - 75, 
			randi()%150 - 75
	)

func physics_update(delta) ->  void:
	
	if entity.engagement_area.get_overlapping_bodies().size() > 0:
		entity._FSM.transition_to("BATTLE_ENGAGE", {"ENTER":null})
		return
		
	# have stopped moving; start waiting
	if entity.velocity == Vector2.ZERO:
		entity.anim_container.set_anim("Idle", "Default")
		
		# only restart timer when its dead
		if timer.time_left <= 0:
			timer.wait_time = wait_time_max - 1 + wait_time_min
			timer.start()
	
	# stop walking if you're in a reasonable distance	
	if abs(entity.position.distance_to(wander_target)) < 0.5:
		wander_target = entity.position
		entity.nav_agent.set_target_location(entity.position)
		entity.velocity = entity.velocity.move_toward(Vector2.ZERO, entity.friction * delta)
		entity.nav_agent.set_velocity(entity.velocity)
		
					
	# move toward wander target
	else:
		entity.move_nav_agent(
			wander_target, 
			delta, 
			entity.stats.max_walk_speed
		)
		entity.anim_container.set_anim("Walk", "Default")
	

func _exit():
	timer.queue_free()
