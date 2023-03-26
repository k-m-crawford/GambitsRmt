class_name GambitAction
extends Resource


@export var action_name = ""
# how far the action can be:
# a) executed
# b) used to target an entity for this action
@export var execution_range = 0
@export var targeting_range = 0

func _while_queued(_e, _delta):
	pass


