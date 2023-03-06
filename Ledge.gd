class_name TileMapLedge
extends Area2D


@export var altitude: int
@export var vertical: bool
@export var upward: bool
@export var leftward: bool

func _change_entity_altitude(entity):
	
	if check_pass(entity.global_position):
		entity.set_collision_mask_value(altitude, false)
		entity.set_collision_mask_value(altitude - 1, true)
		entity.altitude = altitude - 1
		
	entity.z_index = entity.altitude
	entity.set_velocity(Vector2(250, 0))
	entity.move_and_slide()
	entity.velocity = entity.velocity

# check direction entity is passing from
# true means increase in altitude, false decrease
func check_pass(pos):
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

