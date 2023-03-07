class_name AllyBattleMoveState
extends State

var has_action_queued

func enter(_msg := {}) -> void:
	entity.anim_container.set_textures("BattleEngagedMove")
	entity.anim_container.set_anim("Idle", "Battle")
	has_action_queued = false

func physics_update(_delta) -> void:
	
	if not entity._FSM.check_flag("BATTLE_ENGAGED"):
		entity._FSM.transition_to("BATTLE_ENGAGE", {"EXIT":null})
		return
		
	
