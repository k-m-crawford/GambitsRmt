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
@export_category("Behaviors")
@export var FSM_Type:String
@export var _leader_entity_path:NodePath
@export var _behaviors = {
	"Wander": true,
	"FollowLeader": true
}
@export var anim_handler:Resource
@export var friction:int
@export var stats:Resource
@export var debug = false


# ONREADY
@onready var anim_container:AnimationContainer = get_node_or_null("AnimationContainer")
@onready var nav_agent:NavigationAgent2D = get_node_or_null("NavigationAgent2D")

@onready var leader_stray:Area2D = get_node_or_null("EngagementCircles/LeaderStray")
@onready var leader_run_stray:Area2D = get_node_or_null("EngagementCircles/LeaderRunStray")
@onready var engagement_area:Area2D = get_node_or_null("EngagementCircles/InitiationCircle")
@onready var chase_area:Area2D = get_node_or_null("EngagementCircles/ChaseCircle")

@onready var manager = get_node_or_null("..")
@onready var _FSM = get_node_or_null("FSM")

var anim_state
var leader_entity:Entity
var behaviors = {}


func _ready():
	if _leader_entity_path: leader_entity = get_node(_leader_entity_path)

	for k in _behaviors.keys():
		match k:
			"Wander":
				behaviors[k] = WanderBehavior.new(self)

			"FollowLeader":
				behaviors[k] = FollowLeaderBehavior.new(self)
	
	anim_container.initialize()
	_FSM.initialize()
	
	anim_container.anim_tree.animation_finished.connect(_animation_handler)


func set_leader_entity(_leader_entity):
	leader_entity = _leader_entity


func move_nav_agent(location, delta, speed=80):
	nav_agent.set_target_position(location)
		
	var direction = global_position.direction_to(nav_agent.get_next_path_position())
	direction = direction.normalized()
	
	velocity = velocity.move_toward(direction * speed,  
									stats.acceleration * delta)
	nav_agent.set_velocity(velocity)
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	
	update_blend_positions(direction)


func slow_to_stop(delta):
	nav_agent.set_target_position(global_position)
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	nav_agent.set_velocity(velocity)


func update_blend_positions(direction):
	anim_container.update_blend_positions(direction)


func _animation_handler(anim):
	if anim_handler:
		anim_handler.main(anim)


func signal_lock():
	if "signal_lock" in _FSM.state:
		return _FSM.state.signal_lock
	else:
		return true
