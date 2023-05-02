class_name FieldMenuMainMenuUI
extends FieldMenuUI


@onready var magic_submenu = preload("res://UI/FieldMenuUIMagicCategory.tscn")

var leader


func _initialize_menu():
	leader = EntityMgr.get_current_leader().stats
	headers.append(leader.name)
	super._initialize_menu()

func _accept_handler():
	
	match selected:
		
		0:
			pass
	
		1:
			var menu = _spawn_new_menu(magic_submenu)
			menu._initialize_menu()
		
		2:
			pass

