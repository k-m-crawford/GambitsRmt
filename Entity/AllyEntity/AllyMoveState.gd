extends State

enum {
	FOLLOW_LEADER,
	WANDER
}

var mood = FOLLOW_LEADER

func enter(_msg := {}) -> void:
	entity.anim_container.set_anim("Idle", "Default")
	entity.anim_container.set_textures("Move")

func physics_update(delta):
			
	# follow leader
	match mood:
		
		WANDER:
			pass
		
		FOLLOW_LEADER:
			if not entity.leader_entity:
				mood = WANDER
				return

			# walk toward leader
			if not entity.leader_stray.overlaps_body(entity.leader_entity):
				
				if entity.leader_run_stray.overlaps_body(entity.leader_entity):
					entity.move_nav_agent(entity.leader_entity.global_position, delta)
					entity.anim_container.set_anim("Walk", "Default")
					
					if entity._FSM.check_flag("BATTLE_ENGAGED"):
						entity._FSM.transition_to("BATTLE_ENGAGE", {"ENTER":null})
						
				else:
					entity.move_nav_agent(entity.leader_entity.global_position, delta,
										entity.stats.max_run_speed)
					entity.anim_container.set_anim("Run", "Default")


			# close to leader, stop walking
			else:
				
				if entity.velocity == Vector2.ZERO:
					entity.anim_container.set_anim("Idle", "Default")
				else:
					entity.slow_to_stop(delta)
				
		
					
