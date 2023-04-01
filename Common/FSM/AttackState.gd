class_name AttackState
extends State

var hitbox:Area2D

func initialize(_msg := {}) -> void:
	hitbox = entity.attack_pivot.get_node("Hitbox")

func enter(_msg := {}) -> void:
	entity.stun_tick = randf_range(0.6, 1.0)
	entity.anim_container.set_anim("Attack")
	
	var hits = entity.hitbox.get_overlapping_areas()
	
	for hit in hits:
		entity.emit_signal(
			"deal_damage", 
			entity,
			hit.get_parent()
		)
