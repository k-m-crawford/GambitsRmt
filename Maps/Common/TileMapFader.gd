extends TileMap

@export var fadeout_area_path:NodePath

@onready var fadeout_trigger_area = get_node_or_null(fadeout_area_path)
@onready var tween = $Tween

func fadeout_layer(body):
	
	if not body.get_collision_layer_value(8): return
	
	if fadeout_trigger_area.get_overlapping_bodies().size() > 0:
		tween.interpolate_property(
		self, "modulate:a", 1, 0.25, 0.1, 
		Tween.TRANS_LINEAR, Tween.EASE_IN
		)
		
# warning-ignore:return_value_discarded
		tween.start()
		await tween.finished

func fadein_layer(body):
	if not body.get_collision_layer_value(8): return

	tween.interpolate_property(
	self, "modulate:a", 0.25, 1, 0.1, 
	Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	
# warning-ignore:return_value_discarded
	tween.start()
	await tween.finished

