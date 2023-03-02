extends State



func initialize(_msg := {}) -> void:
	pass
	
func enter(_msg := {}) -> void:
	entity.anim_container.set_anim("Idle", "Battle")
#	Targeting.update_target_entities(entity)

func physics_update(delta):
	pass
