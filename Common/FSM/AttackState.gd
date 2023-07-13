class_name AttackState
extends State

var hitbox:Area2D

func initialize(_msg := {}) -> void:
	hitbox = entity.attack_pivot.get_node("Hitbox")

func enter(_msg := {}) -> void:
	entity.stun_tick = randf_range(0.6, 1.0)
	entity.anim_container.set_anim("Attack")
	
	var hits = entity.hitbox.get_overlapping_bodies()
	
	for hit in hits:
		var dmg = _b.dmg_calc(entity.stats.atk, randf_range(1, 1.125), hit.stats.def,
								1, entity.stats.stn, entity.stats.lvl, entity.stats.stn)
		EntityMgr.apply_damage(entity, hit, dmg)
		hit.apply_knockback(entity)
