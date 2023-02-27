extends State

func enter(msg := {}) -> void:
	
	entity.velocity = Vector2.ZERO
	
	if msg.has("ENTER"):
		print("sent set anim")
		entity.anim_container.set_anim("EnterBattleEngagement", "root")
	elif msg.has("EXIT"):
		entity.destroy_target_lines()
		entity.anim_container.set_anim("ExitBattleEngagement", "root")
