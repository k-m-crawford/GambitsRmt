# a static FSM (does not change owners)
class_name Manager_FSM
extends FSM

var manager: Node

func _ready() -> void:
	manager = get_parent()
	
	yield(owner, "ready")
	
	for key in state_scripts.keys():
		states[key] = state_scripts[key].new()
		states[key].manager = get_parent()
		states[key].name = key
		states[key].initialize()
	
	state = states[start_state]
	state.enter()

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if debug:
		print(manager.name, " ", state.name, " -> ", target_state_name)
	
	.transition_to(target_state_name, msg)
