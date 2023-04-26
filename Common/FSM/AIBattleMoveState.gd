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

	if entity.stun_tick > 0:
		entity.stun_tick -= delta
	# if no action queue
	# do gambit ladder
	elif entity.action_queue:
		entity.action_queue._while_queued(entity, delta)
	
	else:
		Gambit.do_gambit_ladder(entity)
	
