class_name GambitAction
extends Resource


@export var action_name = ""
# how far the action can be:
# a) executed
# b) used to target an entity for this action
@export var execution_range = 0
@export var targeting_range = 0

func _while_queued(e:Entity):
	pass
#	if e.global_position.distance_to(e.target_entity)


func _perform_action(e:Entity):
	pass
