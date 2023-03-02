class_name WanderBehavior
extends Behavior

onready var timer = Timer.new()

var wait_time_min = 3
var wait_time_max = 3
var wander_target:Vector2


func _init(_entity):
	._init(_entity)
	wander_target = entity.global_position
	
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = randi() % wait_time_max - 1 + wait_time_min
	# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "start_wander", [entity])

	entity.add_child(timer)
	timer.start()


func start_wander():
	wander_target =  entity.global_position + Vector2(
			randi()%300 - 150, 
			randi()%300 - 150
	)
	entity.nav_agent.set_target_location(wander_target)
	timer.wait_time = randi() % wait_time_max - 1 + wait_time_min


func move(delta):
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
