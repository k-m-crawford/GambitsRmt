class_name BattleEntity
extends Entity

# warning-ignore:unused_signal
signal battle_engagement
# warning-ignore:unused_signal
signal set_target_entity(source, flags, type, AOE)
# warning-ignore:unused_signal
signal deal_damage(amount, entity)

@export var gambits: Array[Gambit] = []


@onready var leader_stray:Area2D = get_node_or_null("RangeAreas/LeaderStray")
@onready var leader_run_stray:Area2D = get_node_or_null("RangeAreas/LeaderRunStray")
@onready var engagement_area:Area2D = get_node_or_null("RangeAreas/EngagementArea")
@onready var chase_area:Area2D = get_node_or_null("RangeAreas/ChaseArea")
@onready var range_area:Area2D = get_node_or_null("RangeAreas/RangeArea")
@onready var range_area_shape:CollisionShape2D = get_node_or_null("RangeAreas/RangeArea/CollisionShape2D")

@onready var attack_pivot:Marker2D = get_node_or_null("AttackPivot")
@onready var hurtbox:Area2D = get_node_or_null("Hurtbox")
@onready var hitbox:Area2D = get_node_or_null("AttackPivot/Hitbox")
@onready var target_lines:Node2D = get_node_or_null("TargetLines")

var target_entity:BattleEntity = null
var target_entities = []
var target_idx = 0

var action_queue = null

func _ready():
	super._ready()
	# warning-ignore:return_value_discarded
	set_target_entity.connect(manager.set_target_entity)
	# warning-ignore:return_value_discarded
	deal_damage.connect(manager.deal_damage)


func update_blend_positions(direction):
	
	if abs(direction.x) > abs(direction.y):
		if direction.x < 0:
			attack_pivot.rotation_degrees = 90
		else:
			attack_pivot.rotation_degrees = 270
	else:
		if direction.y > 0:
			attack_pivot.rotation_degrees = 0
		else:
			attack_pivot.rotation_degrees = 180

	super.update_blend_positions(direction)


func _animation_handler(anim):
	
	# reverse look up from anim mask dict to properly transition
	# TODO: method for if one animation used for multiple masks
	for k in anim_container.anim_mask_dict.keys():
		for v in anim_container.anim_mask_dict[k].values():
			if v == anim:
				anim = anim_container.anim_mask_dict[k].find_key(v)
	
	match anim:
		"EnterBattleEngagement":
			_FSM.transition_to("BATTLE_MOVE")
		"ExitBattleEngagement":
			_FSM.transition_to("MOVE")
		_:
			if anim in ["AttackUp","AttackDown","AttackLeft","AttackRight"]:
				_FSM.transition_to("BATTLE_MOVE", {"from_attack":1})
			


func destroy_target_lines():
	for l in get_children():
		if "TargetLines" in l.get_groups():
			l.kill(TargetIndicator.KILL and TargetIndicator.FADE)
