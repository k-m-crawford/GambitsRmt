class_name BattleEngageState
extends State

func enter(_msg := {}) -> void:
	
	entity.velocity = Vector2.ZERO
	
	if entity._FSM.check_flag("BATTLE_ENGAGED"):
		entity.anim_container.set_anim("EnterBattleEngagement", true)
	else:
		entity.destroy_target_lines()
		entity.action_queue = []
		entity.target_entity = null
		entity.anim_container.set_anim("ExitBattleEngagement", true)
