class_name BattleEntity
extends Entity

# warning-ignore:unused_signal
signal battle_engagement
# warning-ignore:unused_signal
signal to_Manager_set_target_entity(source, flags, type, AOE)
# warning-ignore:unused_signal
signal deal_physical_damage(attacker, defender)
# warning-ignore:unused_signal
signal apply_magical_healing(source, target)
# warning-ignore:unused_signal
signal request_leader_change(dir)

@export var gambits: Array[Gambit] = []
@export var manual_control = false

@onready var chase_area:Area2D = get_node_or_null("RangeAreas/ChaseArea")
@onready var leader_stray:Area2D = get_node_or_null("RangeAreas/LeaderStray")
@onready var engagement_area:Area2D = get_node_or_null("RangeAreas/EngagementArea")
@onready var range_area:ShapeCast2D = get_node_or_null("RangeAreas/RangeArea")

@onready var attack_pivot:Marker2D = get_node_or_null("AttackPivot")
@onready var hurtbox:Area2D = get_node_or_null("Hurtbox")
@onready var hitbox:Area2D = get_node_or_null("AttackPivot/Hitbox")
@onready var target_lines:Node2D = get_node_or_null("TargetLines")

var target_entity:BattleEntity = null
var prev_target:BattleEntity = null
var target_entities = []
var target_idx = 0
var stun_tick = 0
var interruptible = true
var cur_gambit = 0

var action_queue = []

func _ready():
	super._ready()
	if manual_control:
		switch_leader_state()
	# warning-ignore:return_value_discarded
	to_Manager_set_target_entity.connect(EntityMgr.set_target_entity)
	# warning-ignore:return_value_discarded
#	deal_physical_damage.connect(EntityMgr.deal_damage)
	# warning-ignore:return_value_discarded
	apply_magical_healing.connect(EntityMgr.apply_magical_healing)
	battle_engagement.connect(EntityMgr.on_battle_engagement)
	request_leader_change.connect(EntityMgr.get_next_leader)
	

func update_blend_positions(_direction):
	if abs(_direction.x) > abs(_direction.y):
		if _direction.x < 0:
			attack_pivot.rotation_degrees = 90
		else:
			attack_pivot.rotation_degrees = 270
	else:
		if _direction.y > 0:
			attack_pivot.rotation_degrees = 0
		else:
			attack_pivot.rotation_degrees = 180
	super.update_blend_positions(_direction)


func _animation_handler(anim_name):	
	match anim_name:
		"EnterBattleEngagement":
			_FSM.transition_to("BATTLE_MOVE")
		"ExitBattleEngagement":
			_FSM.transition_to("MOVE")
		_:
			if "Attack" in anim_name:
				_FSM.transition_to("BATTLE_MOVE", {"from_attack":1})


func destroy_target_lines():
	for l in get_children():
		if "TargetLines" in l.get_groups():
			l.kill(TargetIndicator.KILL and TargetIndicator.FADE)


func manual_movement(max_speed, delta, direction_override=null):
	# calculate direction
	direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	direction = direction.normalized()
	if direction != Vector2.ZERO:
		
		velocity = velocity.move_toward(direction * max_speed, \
										stats.acceleration * delta)
		if direction_override:
			update_blend_positions(direction_override)
		else:
			update_blend_positions(direction)
	
	return direction


func apply_knockback(attacker):
	if interruptible:
		_FSM.transition_to(
			"KNOCKBACK",
			{
				"knockback_vec": -global_position.direction_to(attacker.global_position),
				"return_state": _FSM.state.name
			}
		)


func switch_leader_state():
	_FSM.switch_reserve_movement()


func set_target_entity(s_target_entity:BattleEntity):
	prev_target = target_entity
	target_entity = s_target_entity
	emit_signal("to_Manager_set_target_entity", self)


func increment_gambit_ladder():
	cur_gambit += 1
	if(cur_gambit > gambits.size() - 1):
		cur_gambit = 0


func reset_gambit_ladder():
	cur_gambit = 0


func query_targets_in_range() -> Array:
	return range_area.collision_result.map(
		func(e):
			return e["collider"]
	)
