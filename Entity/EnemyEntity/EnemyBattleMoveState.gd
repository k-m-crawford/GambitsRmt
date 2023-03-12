class_name EnemyBattleMoveState
extends State

func enter(_msg := {}) -> void:
	entity.anim_container.set_anim("Idle", "Battle")
#	Targeting.update_target_entities(entity)

func physics_update(_delta):
	pass
