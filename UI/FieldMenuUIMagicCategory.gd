class_name FieldMenuUIMagicCategory
extends FieldMenuUI

@onready var action_menu = preload("res://UI/FieldMenuUIActionMenu.tscn")

func _initialize_menu():
	super._initialize_menu()
	var leader = EntityMgr.get_current_leader().stats
	
	if leader.spellbook["BlackMagic"].size() < 1:
		_deactivate_entry(0)
	if leader.spellbook["WhiteMagic"].size() < 1:
		_deactivate_entry(1)
	if leader.spellbook["GreenMagic"].size() < 1:
		_deactivate_entry(2)

func _accept_handler():
	var leader = EntityMgr.get_current_leader().stats
	
	if selected == 0 and active_map[selected]:
		var menu = _spawn_new_menu(action_menu)
		menu.set_menu_entries(leader.spellbook["BlackMagic"], 
				["Black Magic", "MP Cost"])
		menu._initialize_menu()
		
	if selected == 1 and active_map[selected]:
		var menu = _spawn_new_menu(action_menu)
		menu.set_menu_entries(leader.spellbook["WhiteMagic"], 
				["White Magic", "MP Cost"])
		menu.set_spellbook("WhiteMagic")
		menu._initialize_menu()
			
	if selected == 2 and active_map[selected]:
		var menu = _spawn_new_menu(action_menu)
		menu.set_menu_entries(leader.spellbook["GreenMagic"], 
				["Green Magic", "MP Cost"])
		menu._initialize_menu()
