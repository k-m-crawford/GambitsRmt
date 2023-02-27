###
#	Base class for controlling animations of an entity
#	Animation containers have "states" (which state machine)
#	and "animations" (current anim within a state)
#	so you can have Default > Walk, or Battle > Walk
##

class_name AnimationContainer
extends Node2D

# states: format -> { state_name : [list of anims for state] }
export var _anim_states = {}
# anim masks for states
# format -> { state_name : { anim_name : anim_mask } }
# replaces anim_name for state_name with anim_mask
export var anim_mask_dict = {}
export var default_state:String
export var default_anim:String

onready var texture = $Sprite
onready var anim_tree = $AnimationTree
onready var anim_tree_root = $AnimationTree.get("parameters/playback")
onready var anim_masks = $AnimationTree.get("parameters/MaskAnimations/playback")

var anim_states = {}

# warning-ignore:unused_signal
signal enter_battle_engagement
# warning-ignore:unused_signal
signal exit_battle_engagement
# warning-ignore:unused_signal
signal attack_exit_transition

func _ready():
	
	for k in _anim_states.keys():
		anim_states[k] = [$AnimationTree.get("parameters/" + k + "Animations/playback"), _anim_states[k]]

	set_anim("Idle", "Default")
	anim_tree.active = true
	
func set_textures(_type):
	pass
	
# update all blend states for this animation container
func update_blend_positions(direction):
	for state in anim_states.keys():
		for anim in anim_states[state][1]:
			anim_tree.set("parameters/" + state + "Animations/" + 
								anim + "/blend_position", direction)
	
	for k in anim_mask_dict.keys():
		for v in anim_mask_dict[k].values():
			anim_tree.set("parameters/MaskAnimations/" + v + "/blend_position", direction)
	
# change to a new state machine (set of animations) to the animation
# no animation -> default anim for that state machine
func set_anim(anim, state, flags={}):
	
	for k in flags.keys():
		anim_tree.set("parameters/" + k + "/Animations/conditions/" +
						flags[k])
	
	if state in anim_mask_dict.keys():
		if anim in anim_mask_dict[state].keys():
			# it is, travel to the mask animation state & play the mask
			anim_tree_root.travel("MaskAnimations")
			anim_masks.travel(anim_mask_dict[state][anim])
			
	elif state == "root":
		anim_tree_root.travel(anim)
		
	else:
		anim_tree_root.travel(state + "Animations")
		anim_states[state][0].travel(anim)
	
