class_name TileMapLedge
extends Area2D


export(int) var altitude
export(bool) var vertical
export(bool) var upward
export(bool) var leftward

func _change_entity_altitude(entity):
	
	if check_pass(entity.global_position):
		entity.set_collision_mask_bit(altitude, false)
		entity.set_collision_mask_bit(altitude - 1, true)
		entity.altitude = altitude - 1
		
	entity.z_index = entity.altitude
	entity.velocity = entity.move_and_slide(Vector2(250, 0))
	print(entity.altitude)

# check direction entity is passing from
# true means increase in altitude, false decrease
func check_pass(pos):
	
	print(pos, global_position)
	
	if vertical:
		if upward:
			if pos.y < global_position.y:
				return true
			else:
				return false
		else:
			if pos.y > global_position.y:
					return false
			else:
				return true
	elif leftward:
		if pos.x < global_position.x:
			return false
		else:
			return true
	else:
		if pos.x < global_position.x:
			return true
		else:
			return false

