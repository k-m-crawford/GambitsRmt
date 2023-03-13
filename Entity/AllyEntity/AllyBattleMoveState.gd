class_name AllyBattleMoveState
extends State


func enter(_msg := {}) -> void:
	entity.anim_container.set_textures("BattleEngagedMove")
	entity.anim_container.set_anim("Idle", "Battle")


func exit() -> void:
	entity.action_queue = null
	entity.target_entity = null


func physics_update(_delta) -> void:
	
	if not entity._FSM.check_flag("BATTLE_ENGAGED"):
		entity._FSM.transition_to("BATTLE_ENGAGE")
		return

	# if no action queue
	# do gambit ladder
	if entity.action_queue:
		pass
	
	else:
		Gambit.do_gambit_ladder(entity)
	
