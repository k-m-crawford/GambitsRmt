class_name CureGambitAction
extends GambitAction

var i_cure_anim = preload("res://Animations/EffectAnimations/CureAnimation.tscn")

func _execute(e:BattleEntity, _delta):
	var cure_anim = i_cure_anim.instantiate()
	var anim_player = cure_anim.get_node("AnimationPlayer")
	e.target_entity.add_child(cure_anim)
	anim_player.animation_finished.connect(destroy.bind(e, cure_anim))
	anim_player.play("1")
	e.target_entity.anim_container.play_effect("CureFlash")
	e.action_queue.pop_front()


func destroy(_anim, e, anim_obj):
	e.emit_signal("apply_magical_healing", e, e.target_entity)
	anim_obj.queue_free()
