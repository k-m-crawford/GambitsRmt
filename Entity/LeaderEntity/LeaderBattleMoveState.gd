extends State

var alert_flag = false

func exit() -> void:
	signal_lock = true
	entity.target_entities = []
	entity.emit_signal("set_target_entities", entity, [])


func initialize(_msg := {}) -> void:
	# warning-ignore:return_value_discarded
	entity.chase_area.connect("body_exited", Targeting, "on_enemy_leave_chase_area", [entity, signal_lock])
# warning-ignore:return_value_discarded
	entity.chase_area.connect("body_entered", Targeting, "on_enemy_enter_chase_area", [entity, signal_lock])
#	entity.chase_area.connect("body_entered", self, "on_enemy_enter_engagement_area")


func enter(_msg := {}) -> void:
	signal_lock = false
	entity.anim_container.set_textures("BattleEngagedMove")
	entity.anim_container.set_anim("Idle", "Battle")
	Targeting.update_target_entities(entity)


func handle_input(event: InputEvent) -> void:
		
	if event.is_action_pressed("ui_accept"):
		entity._FSM.transition_to("ATTACK")
	
	elif event.is_action_pressed("ui_cancel"):
		entity.emit_signal("set_target_entities", entity, [])
		entity.emit_signal("battle_engagement", "EXIT")
		
	elif event.is_action_pressed("ui_focus_next"):
		Targeting.get_next_target(1, entity)
	
	elif event.is_action_pressed("ui_focus_prev"):
		Targeting.get_next_target(-1, entity)

func physics_update(delta) -> void:
	
	var direction_override = null
	
	if entity.target_entities.size() > 0:
		direction_override = entity.position.direction_to(entity.target_entities[0].position)
	
	var direction = entity.manual_movement(85, delta, direction_override)
	
	if direction != Vector2.ZERO:
		entity.anim_container.set_anim("Walk", "Battle")
	
	else:
		entity.velocity = entity.velocity.move_toward(Vector2.ZERO, entity.friction * delta)
		entity.anim_container.set_anim("Idle", "Battle")

	entity.velocity = entity.move_and_slide(entity.velocity)
