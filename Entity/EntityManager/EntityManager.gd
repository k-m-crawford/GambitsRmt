######
# Manages all entities and required interactions between them (i.e., damage dealing)
# Owns the UI related to field menus and stats / ATB bars etc. (i.e., battle / field-action related)
# Step down from "Scene Management", Entity Manager is agnostic of the map
#####

class_name EntityManager
extends Node

var ally_entities = []
var active_idx:int = 0

var field_menu = false

@onready var field_ui = $FieldUI
@onready var camera = $Camera

@onready var damage_label = preload("res://UI/DamageLabel.tscn")
@onready var target_curve = preload("res://UI/TargetIndicators/TargetIndicatorCurve.tscn")
@onready var target_circle = preload("res://UI/TargetIndicators/TargetIndicatorCircle.tscn")

var target_select:TargetIndicatorCircle

func _ready():
	
	for ally in get_tree().get_nodes_in_group("Allies"):
		ally_entities.append(ally)
		ally.request_leader_change.connect(get_next_leader)
		ally.battle_engagement.connect(on_battle_engagement)
		
	if ally_entities.size() > 0:
		camera.follow_entities(ally_entities)
	
	set_process(true)
	
func _input(event):
	
	if field_menu: return
		
	if event.is_action_pressed("ui_fieldmenu") and ally_entities.size() > 0:
		# instance a target circle for selecting active ally
		target_select = target_circle.instantiate()
		add_child(target_select)
		target_select.setup(
			ally_entities[active_idx].position,
			Vector2(1, 1),
			"Friendly"
		)
		
		field_ui.activate()


func get_next_leader(dir):
	# determine which ally to switch to next
	var next_idx = active_idx + dir
	if(next_idx < 0): next_idx = ally_entities.size() - 1
	elif(next_idx >= ally_entities.size()): next_idx = 0
	
	# retrieve active and next ally
	var active_ally:Entity = ally_entities[active_idx]
	var next_ally:Entity = ally_entities[next_idx]
	
	# retrieve active and next ally FSMs
	var active_ally_fsm:FSM = active_ally.get_node("FSM")
	var next_ally_fsm:FSM = next_ally.get_node("FSM")
	
	# remove FSMs
	active_ally.remove_child(active_ally_fsm)
	next_ally.remove_child(next_ally_fsm)
	
	# switch FSMs
	active_ally.add_child(next_ally_fsm)
	next_ally_fsm.reparent_fsm(active_ally)
	next_ally_fsm.set_owner(active_ally)
	next_ally.add_child(active_ally_fsm)
	active_ally_fsm.reparent_fsm(next_ally)
	active_ally_fsm.set_owner(next_ally)
	
	# get camera
	
		
	# set new leader entity for all entities
	for ally_entity in ally_entities:
		if ally_entity != next_ally:
			ally_entity.set_leader_entity(next_ally)
	
	# set new active idx
	active_idx = next_idx
	
	target_select.move(ally_entities[active_idx].global_position)


func on_battle_engagement():
	for ally in get_tree().get_nodes_in_group("Allies"):
		ally._FSM.set_flag("BATTLE_ENGAGED")
		if ally == ally_entities[active_idx]:
			ally._FSM.transition_to("BATTLE_ENGAGE")


func _on_FieldUI_field_menu_closed():
	target_select.kill(TargetIndicator.KILL and TargetIndicator.FADE)
	field_menu = false


func deal_damage(attacker, defender):
	var dmg = randi() % (attacker.stats.stn - defender.stats.vit) + 1
	defender.stats.hp -= dmg

	var inst = damage_label.instantiate()
	get_parent().add_child(inst)
	inst._execute(dmg, defender.get_global_position())


# TODO: add AOE targeting
func set_target_entities(source, type="Friendly", _AOE=false):
	source.destroy_target_lines()

	if source.target_entity != null:
			var _target_curve = self.target_curve.instantiate()
			_target_curve.setup(source, source.target_entity, type, false)


