extends CanvasLayer

export(Array, String) var commands = ["Ability", "Spells", "Item"]

onready var pointer = $ActionMenu/Pointer
onready var commands_label = [
	$ActionMenu/VBoxContainer/Command1,
	$ActionMenu/VBoxContainer/Command2,
	$ActionMenu/VBoxContainer/Command3
]
onready var action_menu = $ActionMenu

var active = false
var selected = 0
var pointer_default_pos

signal field_menu_closed
signal get_next_leader(dir)

func _ready():
	pointer.get_node("AnimationPlayer").play("Hover")
	pointer_default_pos = pointer.rect_position
	
	for i in range(0, 3):
		commands_label[i].text = commands[i]
	
func _input(event):
	
	if not active: return
	
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
		get_tree().set_input_as_handled()
		activate()
	
	elif event.is_action_pressed("ui_focus_prev"):
		emit_signal("get_next_leader", -1)
		
	elif event.is_action_pressed("ui_focus_next"):
		emit_signal("get_next_leader", 1)
		
	pointer.rect_position = Vector2(pointer_default_pos.x, pointer_default_pos.y + selected * 16)


func activate():
	
	if active:
		action_menu.visible = false
		get_tree().paused = false
		emit_signal("field_menu_closed")
	else:
		action_menu.visible = true
		get_tree().paused = true
		pointer.rect_position = pointer_default_pos
		
	active = !active
		
