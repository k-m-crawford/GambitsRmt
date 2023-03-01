# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name FSM
extends Node

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.

export var state_scripts := {}
export var start_state:String
export var debug:bool

onready var state
onready var states := {}

var entity:Entity
var flags = []

# Emitted when transitioning to a new state.
signal transitioned(state_name)
		
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


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if debug:
		print(entity.name, " ", state.name, " -> ", target_state_name)
	
	# Safety check, you could use an assert() here to report an error if the state name is incorrect.
	# We don't use an assert here to help with code reuse. If you reuse a state in different state machines
	# but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
	if not states.has(target_state_name):
		print("state not found")
		return

	state.exit()
	state = states[target_state_name]
	state.enter(msg)
	emit_signal("transitioned", state.name)


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
