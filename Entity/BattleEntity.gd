class_name BattleEntity
extends Entity

# warning-ignore:unused_signal
signal battle_engagement
# warning-ignore:unused_signal
signal set_target_entities(source, flags, type, AOE)
# warning-ignore:unused_signal
signal deal_damage(amount, entity)

@export var gambits:Resource
@export var attack_targeting_method_resource:Resource

@onready var attack_targeting_method = attack_targeting_method_resource.new()
@onready var attack_pivot:Marker2D = get_node_or_null("AttackPivot")
@onready var hurtbox:Area2D = get_node_or_null("Hurtbox")
@onready var hitbox:Area2D = get_node_or_null("AttackPivot/Hitbox")
@onready var target_lines:Node2D = get_node_or_null("TargetLines")

var target_entities = []
var target_idx = 0

func _ready():
	super._ready()
	# warning-ignore:return_value_discarded
	set_target_entities.connect(manager.set_target_entities)
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
