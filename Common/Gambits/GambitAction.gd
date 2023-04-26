class_name GambitAction
extends Resource

@export var action_name = ""
# how far the action can be:
# a) executed
# b) used to target an entity for this action
@export var execution_range:float = 0.0
@export var targeting_range:float = 0.0
@export var charge_time:float = 0.0

var charge_timer = 0
var patrol = false
var patrol_dest = Vector2.ZERO


func enqueue(e:BattleEntity):
	charge_timer = charge_time
	e.range_area_shape.shape.radius = execution_range
	e.action_queue = self 
	
	if charge_timer > 0:
		e.anim_container.play_effect("Charging")
	
	if e.is_in_group("Allies"):
		EntityMgr.field_ui.party_stats.set_charge_bar_val(e.stats, charge_time)


func _while_queued(e:BattleEntity, delta):
	charge_timer -= delta
	if charge_timer > 0 and e.is_in_group("Allies"):
			EntityMgr.field_ui.party_stats.update_charge_bar(e.stats, charge_timer)
	elif charge_timer <= 0 and e.is_in_group("Allies"):
			EntityMgr.field_ui.party_stats.update_charge_bar(e.stats, 0)
		
	
	var hits = e.range_area.get_overlapping_areas()
	
	if e.target_entity.hurtbox in hits:
		if charge_timer <= 0:
			e.anim_container.stop_charge()
			execute_wrapper(e, delta)
		else:
			e.anim_container.set_anim("BattleIdle")
	else:
		e.move_nav_agent(e.target_entity.global_position, delta)
		e.anim_container.set_anim("BattleMove")


func execute_wrapper(e:BattleEntity, delta):
	EntityMgr.field_ui.party_stats.set_charge_bar_val(e.stats, 1)
	_execute(e, delta)


func _execute(_e, _delta):
	pass


#			_execute(e)
#		else:
#			if patrol:
#				if e.nav_agent.is_navigation_finished():
#					if e.velocity == Vector2.ZERO:
#						e.anim_container.set_anim("BattleIdle")
#						patrol = false
#					else:
#						e.slow_to_stop(delta)
#				else:
#					e.move_nav_agent(patrol_dest, delta)
#					e.anim_container.set_anim("BattleMove")
#
#			else:
#				var angle_diff = abs(e.global_position.angle_to_point(e.target_entity.global_position))
#				print(angle_diff)
#				var low_clamp = angle_diff - angle_diff/8 if angle_diff - angle_diff/8 > 0 else PI*2 + (angle_diff - angle_diff/8)
#				var high_clamp = angle_diff + angle_diff/8 if angle_diff + angle_diff/8 < PI*2 else -PI*2 + (angle_diff + angle_diff/8)
#				angle_diff = randf_range(low_clamp, high_clamp)
#				print(low_clamp, "            ", high_clamp)
#				patrol_dest = Vector2(
#						e.target_entity.global_position.x + cos(angle_diff) * abs(e.global_position.distance_to(e.target_entity.global_position) - 5),
#						e.target_entity.global_position.y + sin(angle_diff) * abs(e.global_position.distance_to(e.target_entity.global_position) - 5)
#					)
#				print(patrol_dest)
#				e.nav_agent.set_target_position(patrol_dest)
#				patrol = true

