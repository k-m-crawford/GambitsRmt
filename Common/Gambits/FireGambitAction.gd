class_name FireGambitAction
extends GambitAction

var i_fire_anim = preload("res://Animations/EffectAnimations/FireAnimation.tscn")

func _execute(e:BattleEntity, _delta):
	var fire_anim = i_fire_anim.instantiate()
	e.target_entity.add_child(fire_anim)
	fire_anim.play_anim("1", e)
	e.target_entity.anim_container.play_effect("HurtFlash")
	e.action_queue.pop_front()
