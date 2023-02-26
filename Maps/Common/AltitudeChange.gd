class_name TileMapStairs
extends Area2D

export(int) var altitude # altitude this altitude changer LEADS to in DIR
enum Dir {UP, DOWN, LEFT, RIGHT}
export(Dir) var direction

func _change_entity_altitude(entity):
	
	# check the direction of passage (true = ascend, false = descend
	if check_pass(entity.global_position):
		print("ascend")
		entity.altitude = altitude 
		entity.set_collision_mask_bit(altitude - 1, false)
		entity.set_collision_mask_bit(altitude, true)
		entity.set_collision_layer_bit(altitude - 1, false)
		entity.set_collision_layer_bit(altitude, true)
	else:
		print("descend")
		entity.altitude = altitude - 1
		entity.set_collision_mask_bit(altitude, false)
		entity.set_collision_mask_bit(altitude - 1, true)
		entity.set_collision_layer_bit(altitude - 1, true)
		entity.set_collision_layer_bit(altitude, false)
	
	entity.z_index = entity.altitude
	print(entity.altitude)

# check direction entity is passing from
# true means increase in altitude, false decrease
func check_pass(pos):
	
	match direction:
		
		Dir.UP:
			if pos.y < global_position.y:
				return true
			else:
				return false
		
		Dir.DOWN:
			if pos.y > global_position.y:
				return true
			else:
				return false
		
		Dir.RIGHT:
			if pos.x > global_position.x:
				return true
			else:
				return false
		
		Dir.LEFT:
			if pos.x < global_position.x:
				return true
			else:
				return false
