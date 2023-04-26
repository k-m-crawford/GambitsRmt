class_name CureGambitAction
extends GambitAction

var i_cure_anim = preload("res://Animations/EffectAnimations/CureAnimation.tscn")

func _execute(e:BattleEntity, _delta):
	var cure_anim = i_cure_anim.instantiate()
	e.target_entity.add_child(cure_anim)
	cure_anim.play_anim("1", e)
	e.target_entity.anim_container.play_effect("CureFlash")
	e.pop_action_queue()
	e.stun_tick = randf_range(2, 2.2)
