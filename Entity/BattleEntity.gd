class_name BattleEntity
extends Entity

# warning-ignore:unused_signal
signal battle_engagement(enter_exit)
# warning-ignore:unused_signal
signal set_target_entities(source, entities, type)

export var gambits:Resource
export var attack_targeting_method_resource:Resource

onready var attack_targeting_method = attack_targeting_method_resource.new()
onready var attack_pivot:Position2D = get_node_or_null("AttackPivot")
onready var hurtbox:Area2D = get_node_or_null("Hurtbox")
onready var hitbox:Area2D = get_node_or_null("AttackPivot/Hitbox")
onready var target_lines:YSort = get_node_or_null("TargetLines")

var target_entities = []

func _ready():
	._ready()
	# warning-ignore:return_value_discarded
	connect("set_target_entities", get_parent(), "set_target_entities")


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

	.update_blend_positions(direction)
	
func destroy_target_lines(fade=true):
	for l in get_children():
		if "TargetLines" in l.get_groups():
			l.kill(fade)

func enter_battle_engagement():
	_FSM.transition_to("BATTLE_MOVE")
	
func exit_battle_engagement():
	_FSM.transition_to("MOVE")

func attack_exit_transition():
	_FSM.transition_to("BATTLE_MOVE")
