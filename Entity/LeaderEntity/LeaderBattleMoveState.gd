extends State

var alert_flag = false

func exit() -> void:
	signal_lock = true
	entity.target_entities = []
	entity.emit_signal("set_target_entities", entity, [])


func initialize(_msg := {}) -> void:
	# warning-ignore:return_value_discarded
	entity.chase_area.connect("body_exited", self, "on_enemy_leave_chase_area")
# warning-ignore:return_value_discarded
	entity.chase_area.connect("body_entered", self, "on_enemy_enter_chase_area")
#	entity.chase_area.connect("body_entered", self, "on_enemy_enter_engagement_area")


func enter(_msg := {}) -> void:
	signal_lock = false
	entity.anim_container.set_textures("BattleEngagedMove")
	entity.anim_container.set_anim("Idle", "Battle")
	update_target_entities()


func handle_input(event: InputEvent) -> void:
		
	if event.is_action_pressed("ui_accept"):
		entity._FSM.transition_to("ATTACK")
	
	elif event.is_action_pressed("ui_cancel"):
		entity.emit_signal("set_target_entities", entity, [])
		entity.emit_signal("battle_engagement", "EXIT")
		
	elif event.is_action_pressed("ui_focus_next"):
		get_next_target(1)
	
	elif event.is_action_pressed("ui_focus_prev"):
		get_next_target(-1)

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


func on_enemy_leave_chase_area(body):
	if signal_lock: return
	
	entity.target_entities.erase(body)
	
	if entity.chase_area.get_overlapping_bodies().size() > 0:
		var new_target = entity.attack_targeting_method.find_targets(
			entity,
			entity.chase_area.get_overlapping_bodies()
		)
		
		print(entity.chase_area.get_overlapping_bodies())
		
		if new_target == entity.target_entities:
			return
		
		entity.target_entities = new_target
		entity.emit_signal("set_target_entities", entity, entity.target_entities)
	
	else:
		entity.emit_signal("set_target_entities", entity, [])
		
func on_enemy_enter_chase_area(body):
	if signal_lock: return
	
	if entity.target_entities.size() == 0:
		entity.target_entities.append(body)
		entity.emit_signal("set_target_entities", entity, entity.target_entities)
	print(entity.target_entities)


func update_target_entities():
	
	if entity.target_entities.size() == 0:
		if entity.chase_area.get_overlapping_bodies().size() > 0:
			entity.target_entities = entity.attack_targeting_method.find_targets(
					entity,
					entity.chase_area.get_overlapping_bodies()
				)
			entity.emit_signal("set_target_entities", entity, entity.target_entities)
		else:
			entity.target_entities = []
			entity.emit_signal("set_target_entities", entity, [])


func get_next_target(dir):
	var targets = entity.chase_area.get_overlapping_bodies()
	
	if targets.size() > 1:
		
		targets = entity.attack_targeting_method.find_targets(
			entity,
			targets,
			true
		)
		
		var i = 0
		
		if entity.target_entities.size() > 0:
			i = targets.find(entity.target_entities[0])
			entity.target_entities.pop_at(0)
		
		i += dir
		if i > targets.size() - 1:
			i = 0
		elif i < 0:
			i = targets.size() - 1
		
		entity.target_entities.append(targets[i])
			
		entity.emit_signal("set_target_entities", entity, entity.target_entities)
