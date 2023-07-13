extends Node2D

@onready var anim = $AnimationPlayer

var e:BattleEntity

func _ready():
	anim.animation_finished.connect(destroy)

func play_anim(level, _e):
	e = _e
	anim.play(level)

func destroy(_anim_name):
	e.emit_signal("apply_magical_healing", e, e.target_entity)
	queue_free()
