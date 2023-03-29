class_name Entity
extends CharacterBody2D

# warning-ignore:unused_signal
signal request_camera(entity)
signal initialize_fsm

enum {
	WANDER,
	FOLLOW_LEADER
}

# EXPORTS
@export var debug = false

@export var _leader_entity_path:NodePath

@export var _behaviors = {
	"Wander": true,
	"FollowLeader": true
}

@export var friction:int
@export var stats:Resource
@export var _FSM:FSM


# ONREADY
@onready var anim_container:AnimationContainer = get_node_or_null("AnimationContainer")
@onready var nav_agent:NavigationAgent2D = get_node_or_null("NavigationAgent2D")

@onready var manager = get_node_or_null("..")

var anim_state
var leader_entity:Entity
var behaviors = {}
var direction:Vector2 = Vector2.ZERO


func _ready():
	if _leader_entity_path: leader_entity = get_node(_leader_entity_path)

	for k in _behaviors.keys():
		match k:
			"Wander":
				behaviors[k] = WanderBehavior.new(self)

			"FollowLeader":
				behaviors[k] = FollowLeaderBehavior.new(self)
	
	
	_FSM.initialize()
	anim_container.hook(self)


func set_leader_entity(_leader_entity):
	leader_entity = _leader_entity


func move_nav_agent(location, delta, speed=80):
	
	nav_agent.set_target_position(location)
		
	direction = global_position.direction_to(nav_agent.get_next_path_position())
	direction = direction.normalized()
	
	velocity = velocity.move_toward(direction * speed,  
									stats.acceleration * delta)
	nav_agent.set_velocity(velocity)
#	set_velocity(velocity)
	move_and_slide()
	
	update_blend_positions(direction)


func slow_to_stop(delta):
	nav_agent.set_target_position(global_position)
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	nav_agent.set_velocity(velocity)


func update_blend_positions(_direction):
	anim_container.update_blend_positions(_direction)


func _animation_handler(_anim):
	pass


func signal_lock():
	if "signal_lock" in _FSM.state:
		return _FSM.state.signal_lock
	else:
		return true
