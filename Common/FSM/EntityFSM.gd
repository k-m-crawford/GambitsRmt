# an FSM for an ENTITY object; can be reparented
# to a new entity
class_name Entity_FSM
extends FSM

var entity:Entity

func _ready() -> void:
	
	entity = get_parent()
	yield(owner, "ready")
	
	for key in state_scripts.keys():
		states[key] = state_scripts[key].new()
		states[key].reparent(entity)
		states[key].name = key
		states[key].initialize()
		
	state = states[start_state]
	state.enter()
	
# Reparents entity's FSM (for when FSMs are changed
# amongst entities)
func reparent(_entity):
	entity = _entity
	entity._FSM = self
	for s in states.keys():
		states[s].reparent(entity)

func set_flag(flag):
	print("set ", flag, " for ", entity.name)
	if flags.has(flag):
		flags.erase(flag)
	else:
		flags.append(flag)

func check_flag(flag):
	return flags.has(flag)
	
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if debug:
		print(entity.name, " ", state.name, " -> ", target_state_name)
	
	.transition_to(target_state_name, msg)
