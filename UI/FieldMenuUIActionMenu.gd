class_name FieldMenuUIActionMenu
extends FieldMenuUI

@onready var _target_circle = preload("res://UI/TargetIndicators/TargetIndicatorCircle.tscn")

var spellbook
var leader:BattleEntity
var action:GambitAction

var target_select = false
var target_pool
var target_idx
var target_circle


func set_spellbook(title):
	leader = EntityMgr.get_current_leader()
	spellbook = leader.stats.spellbook[title]


func _accept_handler():
	var translated_select = selected * page
	action = spellbook[translated_select]
	
	leader.range_area_shape.shape.radius = action.targeting_range
	leader.range_area_shape.shape.draw(leader.get_canvas_item(), Color(0.5,0.5,0.5,0.5))
	_init_target_pool()

func _input(event):
	if target_select:
		
		if event.is_action_pressed("ui_cancel"):
			_exit_target_select()
		elif event.is_action_pressed("ui_left"):
			if target_pool.size() > 0:
				target_idx -= 1
				if target_idx < 0:
					target_idx = target_pool.size() - 1
				target_circle.move(target_pool[target_idx].global_position)
		elif event.is_action_pressed("ui_right"):
			if target_pool.size() > 0:
				target_idx += 1
				if target_idx > target_pool.size() - 1:
					target_idx = 0
				target_circle.move(target_pool[target_idx].global_position)
		elif event.is_action_pressed("ui_accept"):
			leader.prev_target = leader.target_entity
			leader.target_entity = target_pool[target_idx]
			action.enqueue(leader)
			leader.emit_signal("to_Manager_set_target_entity", leader)
			_exit_target_select()
			_exit_field_menu()
	else:
		super._input(event)


func _exit_target_select():
	RenderingServer.canvas_item_clear(leader.get_canvas_item())
	if target_circle: target_circle.queue_free()
	target_select = false


func _init_target_pool():
	target_pool = leader.range_area.get_overlapping_bodies()
	
	if target_pool.size() > 0:
		target_circle = _target_circle.instantiate()
		ui_handle.add_child(target_circle)
		target_circle.setup(target_pool[0].global_position, 1.0, "Friendly")
		target_idx = 0
		target_select = true
