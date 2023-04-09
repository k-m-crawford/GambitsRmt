class_name CureGambitAction
extends GambitAction

var i_cure_anim = preload("res://Animations/EffectAnimations/CureAnimation.tscn")

func _execute(e:BattleEntity, _delta):
	var cure_anim = i_cure_anim.instantiate()
	e.target_entity.add_child(cure_anim)
	cure_anim.get_node("AnimationPlayer").play("Default")
	e.target_entity.anim_container.play_effect("CureFlash")
	e.pop_action_queue()
	e.emit_signal("apply_magical_healing", e, e.target_entity)
	e.stun_tick = randf_range(1, 1.2)
