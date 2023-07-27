class_name SceneManager
extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	EntityMgr.spawn_damage_label.connect(add_child)
	EntityMgr.spawn_projectile.connect(add_child)
