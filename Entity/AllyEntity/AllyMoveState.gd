extends State

enum {
	FOLLOW_LEADER,
	WANDER
}

var mood = FOLLOW_LEADER

func enter(_msg := {}) -> void:
	entity.anim_container.set_anim("Idle", "Default")
	entity.anim_container.set_textures("Move")
	print("ally move state entered")

func physics_update(delta):
			
	# follow leader
	match mood:
		
		WANDER:
			entity.behaviors["Wander"].move(delta)
		
		FOLLOW_LEADER:
			if entity.behaviors["FollowLeader"].move(delta): 
				if entity._FSM.check_flag("BATTLE_ENGAGED"):
					entity._FSM.transition_to("BATTLE_ENGAGE")
				
		
					
