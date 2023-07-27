class_name GambitAction
extends Resource

@export var action_name = ""
@export var default_target_group = ""
@export var mp_cost:float = 0
@export var charge_time:float = 0.0
# how far the action can be:
# a) executed
# b) used to target an entity for this action
@export var execution_range:float = 0.0
@export var targeting_range:float = 0.0
@export var stationary_charging = false

var charge_timer:float = 0
var first_pass = true

var patrol = false
var patrol_dest = Vector2.ZERO

# for auxiliary data, i.e., initial target position
# for charge attacks
var aux:Dictionary

func enqueue(e:BattleEntity):
	charge_timer = 0
	first_pass = true
	e.range_area.shape.radius = execution_range
	e.action_queue.append(self)
	
	if charge_time > 0:
		_charge_func(e)
	
	if e.is_in_group("Allies"):
		EntityMgr.emit_signal("update_field_stats_ui", e.stats, "ChargeBar", 0)

	aux["TargetInitialPosition"] = e.target_entity.global_position


func _while_queued(e:BattleEntity, delta):
	charge_timer += delta
	
	if charge_timer > 0 and e.is_in_group("Allies"):
			EntityMgr.emit_signal("update_field_stats_ui", e.stats, "ChargeBar", charge_timer / charge_time)
	
	var hits = e.query_targets_in_range()

	# stationary charging means the entity will not move while charging,
	# and also that the attack will be executed regardless if the target
	# has left range.
	if stationary_charging or (e.target_entity and e.target_entity in hits):
		if charge_timer >= charge_time:
			e.anim_container.stop_charge()
			execute_wrapper(e, delta)
		elif not e.manual_control and not stationary_charging: #behavior when enemy within range but not charged
			e.anim_container.set_anim("BattleIdle")
	elif not e.manual_control and not stationary_charging: #behavior when out of range
		e.move_nav_agent(e.target_entity.global_position, delta)
		e.anim_container.set_anim("BattleMove")


func execute_wrapper(e:BattleEntity, delta):
	EntityMgr.emit_signal("update_field_stats_ui", e.stats, "ChargeBar", 0)
	_execute(e, delta)


func _charge_func(e):
	e.anim_container.charge_particles.emitting = true


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

