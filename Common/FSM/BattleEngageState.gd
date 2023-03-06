extends State

func enter(_msg := {}) -> void:
	
	entity.velocity = Vector2.ZERO
	
	if entity._FSM.check_flag("BATTLE_ENGAGED"):
		entity.anim_container.set_anim("EnterBattleEngagement", "root")
	else:
		entity.destroy_target_lines()
		entity.anim_container.set_anim("ExitBattleEngagement", "root")
