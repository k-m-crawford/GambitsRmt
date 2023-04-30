class_name FieldUIContainer
extends Control

@onready var _field_menu_main = preload("res://UI/FieldMenuUIMain.tscn")
@onready var field_stats_ui:FieldStatsUI = $FieldStatsUI

var has_focus = true

func _ready():
	EntityMgr.update_field_stats_ui.connect(_on_update_field_stats_ui)
	EntityMgr.spawn_damage_label.connect(add_child)


func _input(event):
	if not has_focus: return
	
	if event.is_action_pressed("ui_fieldmenu"):
		get_tree().paused = true
		var field_menu_main = _field_menu_main.instantiate()
		field_menu_main.closed_menu.connect(_on_field_menu_closed)
		add_child(field_menu_main)
		field_menu_main.visible = true
		field_menu_main.has_focus = true
		has_focus = false


func _on_field_menu_closed():
	get_tree().paused = false
	has_focus = true


func _on_update_field_stats_ui(who, what, aux):
	match what:
		"HP":
			field_stats_ui.update_hitpoints(who)
		"ChargeBarSet":
			field_stats_ui.set_charge_bar_val(who, aux)
		"ChargeBarUpdate":
			field_stats_ui.update_charge_bar(who, aux)

