class_name Entity
extends KinematicBody2D

# warning-ignore:unused_signal
signal request_camera(entity)

enum {
	WANDER,
	FOLLOW_LEADER
}

# EXPORTS
export var _leader_entity_path:NodePath
export var friction:int
export var stats:Resource
export var altitude = 0
export var _behaviors = {
	"Wander": true,
	"FollowLeader": true
}
export var debug = false


# ONREADY
onready var anim_container = get_node_or_null("AnimationContainer")
onready var camera_grab:RemoteTransform2D = get_node_or_null("CameraGrab")
onready var nav_agent:NavigationAgent2D = get_node_or_null("NavigationAgent2D")

onready var leader_stray:Area2D = get_node_or_null("EngagementCircles/LeaderStray")
onready var leader_run_stray:Area2D = get_node_or_null("EngagementCircles/LeaderRunStray")
onready var engagement_area:Area2D = get_node_or_null("EngagementCircles/InitiationCircle")
onready var chase_area:Area2D = get_node_or_null("EngagementCircles/ChaseCircle")

onready var manager = get_node_or_null("..")


var velocity = Vector2.ZERO
var anim_state
var _FSM
var leader_entity:Entity
var behaviors = {}


func _ready():
	if anim_container:
		anim_container.set_anim("Idle", "Default")
	
	if _leader_entity_path: leader_entity = get_node(_leader_entity_path)
	
	_FSM = get_node_or_null("FSM")
	
	for k in _behaviors.keys():
		
		match k:
			"Wander":
				behaviors[k] = WanderBehavior.new(self)

			"FollowLeader":
				behaviors[k] = FollowLeaderBehavior.new(self)

	
func set_leader_entity(_leader_entity):
	leader_entity = _leader_entity

func move_nav_agent(location, delta, speed=80):
	nav_agent.set_target_location(location)
		
	var direction = global_position.direction_to(nav_agent.get_next_location())
	direction = direction.normalized()
	
	velocity = velocity.move_toward(direction * speed,  
									stats.acceleration * delta)
	nav_agent.set_velocity(velocity)
	velocity = move_and_slide(velocity)
	
	update_blend_positions(direction)

func slow_to_stop(delta):
	nav_agent.set_target_location(global_position)
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	nav_agent.set_velocity(velocity)

func update_blend_positions(direction):
	anim_container.update_blend_positions(direction)
