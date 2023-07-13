class_name AIBattleMoveState
extends State


func enter(_msg := {}) -> void:
	entity.anim_container.set_textures("BattleEngagedMove")
	entity.anim_container.set_anim("BattleIdle")


#func exit() -> void:
#	entity.action_queue = null


func physics_update(delta) -> void:
	if not entity._FSM.check_flag("BATTLE_ENGAGED"):
		entity._FSM.transition_to("BATTLE_ENGAGE")
		return
	
	if entity.is_in_group("Enemies") and not entity.target_entity:
		var hits = entity.chase_area.get_overlapping_bodies()
		if hits.size() > 0:
			entity.target_entity = hits[0]
	
	if entity.stun_tick > 0:
		entity.stun_tick -= delta
		entity.move_nav_agent(entity.target_entity.global_position, delta)
		entity.anim_container.set_anim("Move")
	# if no action queue
	# do gambit ladder
	elif entity.action_queue.size() > 0:
		entity.action_queue[0]._while_queued(entity, delta)
	
	else:
		Gambit.do_gambit_ladder(entity)
	
