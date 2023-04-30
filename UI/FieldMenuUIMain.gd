class_name FieldMenuMainMenuUI
extends FieldMenuUI

func _initialize_menu():
	headers[0] = EntityMgr.get_current_leader().stats.name
	super._initialize_menu()

func _accept_handler():
	
	match selected:
		
		0:
			pass
	
		1:
			pass
		
		2:
			pass

