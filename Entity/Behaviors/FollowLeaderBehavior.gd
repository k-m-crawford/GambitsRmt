class_name FollowLeaderBehavior 
extends Behavior

func _init(_entity=null):
	super._init(_entity)


# returns true if this entity should enter a battle engagement
# (entity deals w callback, so if non battle entity, do nothing
# w return value in FSM state)
func move(delta) -> bool:

	if not entity.leader_entity:
		return false

	# walk toward leader
	if not entity.leader_stray.overlaps_body(entity.leader_entity):
		
		if entity.leader_run_stray.overlaps_body(entity.leader_entity):
			entity.move_nav_agent(entity.leader_entity.global_position, delta)
			entity.anim_container.set_anim("Walk", "Default")
			return true

		else:
			entity.move_nav_agent(entity.leader_entity.global_position,
					delta, entity.stats.max_run_speed)
			entity.anim_container.set_anim("Run", "Default")	
			return false

	# close to leader, stop walking
	else:
		if entity.velocity == Vector2.ZERO:
			entity.anim_container.set_anim("Idle", "Default")
			return true
			
		else:
			entity.slow_to_stop(delta)
			return false
