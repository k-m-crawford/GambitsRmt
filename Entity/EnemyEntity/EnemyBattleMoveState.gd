extends State

func initialize(_msg := {}) -> void:
	pass
	
func enter(_msg := {}) -> void:
	entity.anim_container.set_anim("Idle", "Battle")
	
