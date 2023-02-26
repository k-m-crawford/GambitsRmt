extends State

var hitbox:Area2D

signal deal_damage(amount, entity)

func initialize(_msg := {}) -> void:
	hitbox = entity.attack_pivot.get_node("Hitbox")
	# warning-ignore:return_value_discarded
	#TODO: uncouple
#	connect("deal_damage", entity.get_node_or_null("/root/SceneManager/EntityManager"), "deal_damage")
	
func enter(_msg := {}) -> void:
	entity.anim_container.set_anim("Attack", "Battle")
	
	var hits = entity.hitbox.get_overlapping_areas()
	
	for hit in hits:
		emit_signal(
			"deal_damage", 
			entity,
			hit.get_parent()
		)
	
func _attack_finished():
	entity._FSM.transition_to("MOVE")
