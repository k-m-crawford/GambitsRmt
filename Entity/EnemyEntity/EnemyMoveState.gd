class_name EnemyMoveState
extends State


func physics_update(delta) ->  void:
	if entity.engagement_area.get_overlapping_bodies().size() > 0:
		entity._FSM.set_flag("BATTLE_ENGAGED")
		entity._FSM.transition_to("BATTLE_ENGAGE")
		return

	entity.behaviors["Wander"].move(delta)
