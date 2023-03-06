extends State

func enter(_msg := {}) -> void:

func physics_update(delta) ->  void:
	if entity.engagement_area.get_overlapping_bodies().size() > 0:
		entity._FSM.transition_to("BATTLE_ENGAGE")
		return

	entity.behaviors["Wander"].move(delta)
