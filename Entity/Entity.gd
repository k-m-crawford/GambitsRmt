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

#@export_group("Animation")
#@export var _animation_container:PackedScene

@export_group("FSM")
@export var __FSM:PackedScene
@export_enum("Allies", "Enemies", "NPCs") var group_type: String

@export_group("Stats")
@export var stats:EntityStats
@export var friction:int

@export_group("Behaviors")
@export var _behaviors = {
	"Wander": true,
	"FollowLeader": true
}
@export var _leader_entity_path:NodePath

# ONREADY
@onready var anim_container:AnimationContainer = get_node_or_null("AnimationContainer")
@onready var nav_agent:NavigationAgent2D = get_node_or_null("NavigationAgent2D")

var anim_state
var _FSM:FSM
var leader_entity:Entity
var behaviors = {}
var direction:Vector2 = Vector2.ZERO


func _ready():
	if _leader_entity_path: leader_entity = get_node(_leader_entity_path)
	
	add_to_group(group_type)
	
	for k in _behaviors.keys():
		match k:
			"Wander":
				behaviors[k] = WanderBehavior.new(self)
				
			"FollowLeader":
				behaviors[k] = FollowLeaderBehavior.new(self)

	anim_container.hook(self)
	
	_FSM = __FSM.instantiate()
	self.add_child(_FSM)
	_FSM.hook(self)


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
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	nav_agent.set_velocity(velocity)
	move_and_slide()


func update_blend_positions(_direction):
	anim_container.update_blend_positions(_direction)


func _animation_handler(_anim):
	pass


func signal_lock():
	if "signal_lock" in _FSM.state:
		return _FSM.state.signal_lock
	else:
		return true
