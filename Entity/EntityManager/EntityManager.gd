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
	
	for e in get_children():
		#TODO: decouple UI from Entity Manager so dont have to do this
		if e.get_class() == "CharacterBody2D": 
			e.hook(self)
		if e  in get_tree().get_nodes_in_group("Allies"):
			ally_entities.append(e)
			e.request_leader_change.connect(get_next_leader)
			e.battle_engagement.connect(on_battle_engagement)
			e.set_leader_entity(ally_entities[0])
	
	if ally_entities.size() > 0:
		ally_entities[0].switch_leader_state()
		camera.follow_entities([ally_entities[0]])
		
#	camera.follow_entities([$Imp])
	
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
	
	active_ally.switch_leader_state()
	next_ally.switch_leader_state()
	
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


func deal_physical_damage(attacker:BattleEntity, defender:BattleEntity):
	var dmg:int = (attacker.stats.stn * randf_range(1, 1.125) - defender.stats.vit) * \
			attacker.stats.stn * (attacker.stats.lvl+attacker.stats.stn)/256

	defender.stats.hp -= dmg
#	defender.anim_container.set_textures("DrawWeapon")
#	defender.anim_container.set_anim("Hit")
	defender.anim_container.play_effect("HurtFlash")
	
	if defender.is_in_group("Allies"):
		field_ui.party_stats.update_hitpoints(defender.stats)

	if defender.is_interruptible(): 	
		defender._FSM.transition_to(
			"KNOCKBACK",
			{
				"knockback_vec": -defender.global_position.direction_to(attacker.global_position),
				"return_state": defender._FSM.state.name
			}
		)

	var inst = damage_label.instantiate()
	get_parent().add_child(inst)
	inst._execute(dmg, defender.get_global_position())


func apply_magical_healing(source:BattleEntity, target:BattleEntity):
	var dmg:int = 20 * randf_range(1, 1.125) * (2 + source.stats.mag * \
			(source.stats.lvl+source.stats.mag)/256)
	
	target.stats.hp += dmg
	if target.stats.hp > target.stats.max_hp: target.stats.hp = target.stats.max_hp
	
	if target.is_in_group("Allies"):
		field_ui.party_stats.update_hitpoints(target.stats)
	
	var inst = damage_label.instantiate()
	inst.modulate = Color(0, 1, 0, 1)
	get_parent().add_child(inst)
	inst._execute(dmg, target.get_global_position())

# TODO: add AOE targeting
func set_target_entity(source, _AOE=false):
	source.destroy_target_lines()
	
	var type = "Friendly" if source.is_in_group("Allies") else "Antagonistic"
	
	if source.target_entity != null and source.target_entity != source.prev_target:
			var _target_curve = self.target_curve.instantiate()
			_target_curve.setup(source, source.target_entity, type, false)
