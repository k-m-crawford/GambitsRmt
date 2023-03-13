class_name GambitAction
extends Resource


@export var action_name = ""
# how far the action can be:
# a) executed
# b) used to target an entity for this action
@export var execution_range = 0
@export var targeting_range = 0
@export var action_bits: Array[GambitActionBit]
# format = { index of actionbit : [index of conditional bit(s)] }
@export var conditionals := {}
@export var trigger_index: int = 0

func while_queued(e:Entity):
	if action_bits[trigger_index].complete == true: perform_action(e)
	
	else:
		
		var i = 0
		while i < action_bits.size():
			
			if action_bits[i].complete: continue
			
			var p = true
			if i in conditionals.keys():
				for j in range(0, conditionals[i].size()):
					if not action_bits[j].complete: p = false
			if p: action_bits[i]._while_queued(e)
			
			if i == trigger_index and action_bits[i].complete:
				i = action_bits.size()
			
			i += 1

func perform_action(e:Entity):
	print("ACTIONED!")
