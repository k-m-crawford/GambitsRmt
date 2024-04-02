class_name FieldMenuUI
extends NinePatchRect

signal closed_menu

@export var has_focus = true
@export var static_menu = true

@export var headers:PackedStringArray

@export var commands:PackedStringArray
@export var footnotes:PackedStringArray

@onready var pointer = $Pointer

@onready var command_label = [
	$VBoxContainer/Command0/Name,
	$VBoxContainer/Command1/Name,
	$VBoxContainer/Command2/Name,
	$VBoxContainer/Command3/Name,
	$VBoxContainer/Command4/Name,
	$VBoxContainer/Command5/Name,
]
@onready var active_map = [
	1, 1, 1, 1, 1, 1
]
@onready var footnote_label = [
	$VBoxContainer/Command0/Val,
	$VBoxContainer/Command1/Val,
	$VBoxContainer/Command2/Val,
	$VBoxContainer/Command3/Val,
	$VBoxContainer/Command4/Val,
	$VBoxContainer/Command5/Val
]
@onready var command_container = [
	$VBoxContainer/Command0,
	$VBoxContainer/Command1,
	$VBoxContainer/Command2,
	$VBoxContainer/Command3,
	$VBoxContainer/Command4,
	$VBoxContainer/Command5,
]

@onready var left_page_pointer = $LeftPagePointer
@onready var right_page_pointer = $RightPagePointer
@onready var menu_title = $Header0
@onready var menu_subtitle = $Header1

var selected = 0
var page = 0
var max_page = 0
var page_size = 0
var pointer_default_pos
var pointer_tween
var left_page_tween
var right_page_tween
var parent_menu
var ui_handle
var depth = 0


func set_menu_entries(entries, s_headers):
	for entry in entries:
		commands.append(entry.action_name)
		footnotes.append(str(entry.mp_cost))
	headers = s_headers


func _initialize_menu():
	
	global_position = Vector2(25*(depth+1), 220-(depth*10))
	
	if headers.size() > 0:
		menu_title.text = headers[0]
		menu_title.visible = true
	if headers.size() > 1:
		menu_subtitle.text = headers[1]
		menu_subtitle.visible = true
		
	max_page = ceil(float(commands.size()) / 6)
	pointer_default_pos = pointer.position
	
	if max_page < 2:
		position.y = position.y + 20 * (6 - commands.size())
	
	update_page()
	
	# SET UP POINTER TWEEN
	pointer_tween = create_tween()
	pointer_tween.tween_property(
			pointer, "position:x",
			pointer.position.x, 0.5
		).set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN)
	pointer_tween.tween_property(
		pointer, "position:x",
		pointer.position.x+3, 0.5
	).set_trans(Tween.TRANS_LINEAR) \
	.set_ease(Tween.EASE_IN)
	pointer_tween.set_loops()
	pointer_tween.play()
	
	# PAGE ARROW TWEEN + DISPLAY
	if max_page > 1:
		left_page_tween = create_tween()
		right_page_tween = create_tween()
		
		
		left_page_tween.tween_property(
			left_page_pointer, "position:x",
			left_page_pointer.position.x, 0.5
		).set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN)
		left_page_tween.tween_property(
			left_page_pointer, "position:x",
			left_page_pointer.position.x-3, 0.5
		).set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN)
		
		right_page_tween.tween_property(
			right_page_pointer, "position:x",
			right_page_pointer.position.x, 0.5
		).set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN)
		right_page_tween.tween_property(
			right_page_pointer, "position:x",
			right_page_pointer.position.x+3, 0.5
		).set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN)
		
		left_page_tween.set_loops()
		left_page_tween.play()
		right_page_tween.set_loops()
		right_page_tween.play()
		left_page_pointer.visible = true
		right_page_pointer.visible = true
	
	pointer_default_pos = pointer.position
	has_focus = true


func _ready():
	if static_menu: _initialize_menu()


func _input(event):
	if not has_focus: return
	
	if event.is_action_pressed("ui_down"):
		selected += 1
		if selected > page_size - 1:
			selected = page_size - 1
	elif event.is_action_pressed("ui_up"):
		selected -= 1
		if selected < 0:
			selected = 0
	
	elif event.is_action_pressed("ui_left"):
		page -= 1
		if page < 0:
			page = max_page - 1
		update_page()
	
	elif event.is_action_pressed("ui_right"):
		page += 1
		if page > max_page - 1:
			page = 0
		update_page()
	
	elif event.is_action_pressed("ui_accept"):
		_accept_handler()
	
	elif event.is_action_pressed("ui_cancel"):
		_release_focus()

	pointer.position = Vector2(pointer_default_pos.x, pointer_default_pos.y + selected * 19)
	pointer.visible = true

func update_page():
	size.y = 0
	page_size = 0
	for i in range(page*6, page*6+6):
		if i < commands.size():
			command_label[i - page*6].text = commands[i]
			if i < footnotes.size() and headers.size() > 1:
				footnote_label[i - page*6].text = footnotes[i]
				footnote_label[i - page*6].visible = true
			command_container[i - page*6].visible = true
			size.y += 20
			page_size += 1
		else:
			command_container[i - page*6].visible = false
	
	if headers.size() < 2:
		size.x = 100
	else:
		size.x = 198
	
	size.y += 7
	
	left_page_pointer.position.y = size.y/2 - left_page_pointer.size.y/2
	right_page_pointer.position.y = size.y/2 - left_page_pointer.size.y/2
	
	selected = 0
	pointer.position = pointer_default_pos


func _spawn_new_menu(tscn):
	has_focus = false
	var child_menu = tscn.instantiate()
	child_menu.parent_menu = self
	child_menu.depth = depth + 1
	ui_handle.hook_menu(child_menu)
	if ui_handle:
		ui_handle.add_child(child_menu)
	modulate = Color(1,1,1,0.2)
	return child_menu


func _accept_handler():
	pass


func _deactivate_entry(idx):
	if idx < commands.size():
		active_map[idx] = 0
		command_container[idx].modulate = Color(0.4, 0.4, 0.4, 1)


func _retake_focus():
	has_focus = true
	modulate = Color(1, 1, 1, 1)
	pointer.visible = true


func _release_focus():
	has_focus = false 
	pointer.visible = false
	get_viewport().set_input_as_handled()
	parent_menu._retake_focus()
	queue_free()


func _exit_field_menu():
	if depth == 0:
		_release_focus()
	else:
		parent_menu._exit_field_menu()
		_release_focus()
