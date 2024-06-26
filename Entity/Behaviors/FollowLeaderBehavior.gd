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
		
		if entity.leader_entity.is_running:
			entity.move_nav_agent(entity.leader_entity.global_position, delta)
			entity.anim_container.set_anim("Run")
			return false
		else:
			entity.move_nav_agent(entity.leader_entity.global_position, delta)
			if entity._FSM.check_flag("BATTLE_ENGAGED"): entity.anim_container.set_anim("BattleMove")
			else: entity.anim_container.set_anim("Move")
			return false

	# close to leader, stop walking
	else:
		if entity.velocity == Vector2.ZERO:
			entity.anim_container.set_anim("Idle")
			return true
			
		else:
			entity.slow_to_stop(delta)
			return false
