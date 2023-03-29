class_name LeaderMoveState
extends State

var cur_max_speed

func enter(_msg := {}) -> void:
	if Input.is_action_pressed("ui_cancel"):
		cur_max_speed = entity.stats.max_run_speed
	else:
		cur_max_speed = entity.stats.max_walk_speed
		
	entity.anim_container.set_textures("Move")

func handle_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_accept"):
		entity.emit_signal("battle_engagement")

	if event.is_action_pressed("ui_cancel"):
		cur_max_speed = entity.stats.max_run_speed
	elif event.is_action_released("ui_cancel"):
		cur_max_speed = entity.stats.max_walk_speed


func physics_update(delta):
	
	var direction = entity.manual_movement(cur_max_speed, delta)
	
	if direction != Vector2.ZERO:
		if cur_max_speed == entity.stats.max_walk_speed:
			entity.anim_container.set_anim("Move")
		else:
			entity.anim_container.set_anim("Run")
	
	else:
		entity.velocity = entity.velocity.move_toward(Vector2.ZERO, entity.friction * delta)
		entity.anim_container.set_anim("Idle")

#	entity.set_velocity(entity.velocity)
	entity.move_and_slide()
	entity.velocity = entity.velocity
