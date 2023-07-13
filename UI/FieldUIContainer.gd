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
		hook_menu(field_menu_main)
		field_menu_main.parent_menu = self
		add_child(field_menu_main)
		field_menu_main.visible = true
		field_menu_main.has_focus = true
		has_focus = false


func hook_menu(menu):
	menu.ui_handle = self


func _on_update_field_stats_ui(who, what, aux):
	match what:
		"HP":
			field_stats_ui.update_hitpoints(who)
		"ChargeBar":
			field_stats_ui.update_charge_bar(who, aux)


func _retake_focus():
	has_focus = true
	get_tree().paused = false

