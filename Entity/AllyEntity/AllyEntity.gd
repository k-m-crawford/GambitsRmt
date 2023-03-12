class_name AllyEntity
extends BattleEntity

@onready var visibility_node = $VisibleOnScreenNotifier2D

# warning-ignore:unused_signal
signal request_leader_change(dir)

func _init():
	add_to_group("Allies")


func manual_movement(max_speed, delta, direction_override=null):
	var direction
	# calculate direction
	direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	direction = direction.normalized()
	if direction != Vector2.ZERO:
		
		velocity = velocity.move_toward(direction * max_speed, \
										stats.acceleration * delta)
		if direction_override:
			update_blend_positions(direction_override)
		else:
			update_blend_positions(direction)
			
	return direction

