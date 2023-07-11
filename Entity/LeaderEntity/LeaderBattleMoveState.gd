class_name LeaderBattleMoveState
extends State

var signal_lock = true
var alert_flag = false

func exit() -> void:
	signal_lock = true
	entity.destroy_target_lines()


func enter(_msg := {}) -> void:
	signal_lock = false
	entity.anim_container.set_textures("BattleEngagedMove")
	entity.anim_container.set_anim("BattleIdle")
	
	# retrieve a target (closest)
	if not entity.target_entity:
		entity.set_target_entity(
			Gambit.get_next_target(entity, "Enemies")
		)

func handle_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_accept") and entity.stun_tick <= 0 and \
			entity.action_queue.size() < 1:
		entity._FSM.transition_to("ATTACK")

	elif event.is_action_pressed("ui_cancel"):
		entity.emit_signal("battle_engagement")

	elif event.is_action_pressed("ui_focus_next"): 
		entity.set_target_entity(
			Gambit.get_next_target(entity, "Enemies", 1)
		)

	elif event.is_action_pressed("ui_focus_prev"): 
		entity.set_target_entity(
			Gambit.get_next_target(entity, "Enemies", -1)
		)


func physics_update(delta) -> void:
	
	if entity.stun_tick > 0:
		entity.stun_tick -= delta
	elif entity.action_queue.size() > 0:
		print(entity)
		entity.action_queue[0]._while_queued(entity, delta)
	
	var direction_override = null
	
	if entity.target_entity != null:
		direction_override = entity.global_position.direction_to(
			entity.target_entity.global_position
		)
	
	var direction = entity.manual_movement(85, delta, direction_override)
	
	if direction != Vector2.ZERO:
		entity.anim_container.set_anim("BattleMove")
	
	else:
		entity.velocity = entity.velocity.move_toward(Vector2.ZERO, entity.friction * delta)
		entity.anim_container.set_anim("BattleIdle")

	entity.set_velocity(entity.velocity)
	entity.move_and_slide()
	entity.velocity = entity.velocity
