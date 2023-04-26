class_name FieldUIActionMenu
extends NinePatchRect

@export var commands = ["Ability", "Spells", "Item"] # (Array, String)

@onready var pointer = $Pointer
@onready var commands_label = [
	$VBoxContainer/Command1,
	$VBoxContainer/Command2,
	$VBoxContainer/Command3
]

var selected = 0
var pointer_default_pos
var tween

func _ready():
	tween = create_tween()
	tween.stop()
	
	tween.tween_property(
		pointer, "position:x",
		5, 1
	).set_trans(Tween.TRANS_LINEAR) \
	.set_ease(Tween.EASE_IN)
	tween.tween_property(
		pointer, "position:x",
		8, 1
	).set_trans(Tween.TRANS_LINEAR) \
	.set_ease(Tween.EASE_IN)
	tween.set_loops()
	tween.play()
	pointer_default_pos = pointer.position
	
	for i in range(0, 3):
		commands_label[i].text = commands[i]

func _input(event):
	
	if event.is_action_pressed("ui_down"):
		selected += 1
		if selected > commands_label.size() - 1:
			selected = commands_label.size() - 1
	elif event.is_action_pressed("ui_up"):
		selected -= 1
		if selected < 0:
			selected = 0
	elif event.is_action_pressed("ui_fieldmenu") or \
		event.is_action_pressed("ui_cancel"):
		pass

	pointer.position = Vector2(pointer_default_pos.x, pointer_default_pos.y + selected * 18)
	print(pointer.position)
