extends State

export var wait_time_min = 3
export var wait_time_max = 3

var wander

func initialize(_msg := {}) -> void:
	wander = Behaviors.WanderBehavior.new(entity)


func physics_update(delta) ->  void:
	if entity.engagement_area.get_overlapping_bodies().size() > 0:
		entity._FSM.transition_to("BATTLE_ENGAGE", {"ENTER":null})
		return

	wander.move(entity, delta)


func _exit():
	wander.queue_free()
