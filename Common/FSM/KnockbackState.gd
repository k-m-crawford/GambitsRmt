class_name KnockbackState
extends State

var knockback_vec:Vector2 = Vector2.ZERO
var return_state:String
var knockback_tick = 0

func enter(msg:={}):
	knockback_vec = msg["knockback_vec"]
	
	_b.debug("RET STATE" + msg["return_state"], entity)
	
	if msg["return_state"] != "KNOCKBACK": return_state = msg["return_state"]
	knockback_tick += 0.1
	
	entity.velocity = Vector2.ZERO
	entity.move_and_slide()


func physics_update(delta):
	knockback_tick -= delta
	
	if knockback_tick < 0:
		entity._FSM.transition_to(return_state)
	else:
		entity.velocity = entity.velocity.move_toward(
			knockback_vec * 450,
			2250 * delta
		)
		
		entity.move_and_slide()

func exit():
	entity.velocity = Vector2.ZERO
	entity.move_and_slide()
