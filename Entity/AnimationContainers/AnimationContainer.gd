###
#	Base class for controlling animations of an entity
#	Animation containers have "states" (which state machine)
#	and "animations" (current anim within a state)
#	so you can have Default > Walk, or Battle > Walk
##

class_name AnimationContainer
extends Node2D


@onready var texture = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var emitter = $ParticleEmitter
@onready var direction = "Down"
@onready var effects_player:AnimationPlayer = get_node_or_null("EffectsPlayer")

signal animation_finished(anim)

func _ready():
	anim.play("Idle/Down")


func hook(e:Entity):
	anim.animation_finished.connect(e._animation_handler)


func set_textures(_type):
	pass


# update all blend states for this animation container
func update_blend_positions(_direction):
	var dirvec = _direction.round()
	
	if dirvec.x < 0:
		direction = "Left"
	elif dirvec.x > 0:
		direction = "Right"
	elif dirvec.y > 0:
		direction = "Down"
	elif dirvec.y < 0:
		direction = "Up"

# change to a new state machine (set of animations) to the animation
# no animation -> default anim for that state machine
func set_anim(s_anim, no_dir=false):
	
	if anim.get_assigned_animation() == s_anim + "/" + direction or \
			anim.get_assigned_animation() == s_anim:
		return
	elif no_dir:
		anim.play(s_anim)
	else:
		anim.play(s_anim + "/" + direction)


func move_layer(node_path:String, layer:int):
	move_child(get_node(node_path), layer)


func play_effect(effect:String):
	effects_player.play(effect)
