extends State

func physics_update(delta) ->  void:
	pass
	if entity.engagement_area.get_overlapping_bodies().size() > 0:
		entity._FSM.transition_to("BATTLE_ENGAGE", {"ENTER":null})
		return

	entity.behaviors["Wander"].move(delta)
