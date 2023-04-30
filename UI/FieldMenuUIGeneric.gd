class_name FieldMenuUI
extends NinePatchRect

signal closed_menu

@export var has_focus = true

@export var headers = []

@export var commands = [
	"Dummy"
]# (Array, String)
@export var footnotes = []


@onready var pointer = $Pointer
@onready var command_label = [
	$VBoxContainer/Command0/Name,
	$VBoxContainer/Command1/Name,
	$VBoxContainer/Command2/Name,
	$VBoxContainer/Command3/Name,
	$VBoxContainer/Command4/Name,
	$VBoxContainer/Command5/Name,
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


func _initialize_menu():
	if headers.size() > 0:
		menu_title.text = headers[0]
		menu_title.visible = true
	if headers.size() > 1:
		menu_subtitle.text = headers[1]
		menu_subtitle.visible = true
		
	max_page = ceil(float(commands.size()) / 6)
	pointer_default_pos = pointer.position
	
	if max_page < 2:
		position.y = position.y + 20 * commands.size()
	
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
	_initialize_menu()


func _input(event):
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
	
	elif event.is_action_pressed("ui_fieldmenu") or \
		event.is_action_pressed("ui_cancel"):
		has_focus = false 
		emit_signal("closed_menu")
		get_viewport().set_input_as_handled()	
		queue_free()

	pointer.position = Vector2(pointer_default_pos.x, pointer_default_pos.y + selected * 19)


func update_page():
	size.y = 0
	page_size = 0
	for i in range(page*6, page*6+6):
		if i < commands.size():
			command_label[i - page*6].text = commands[i]
			if i < footnotes.size():
				footnote_label[i - page*6].text = footnotes[i]
			command_container[i - page*6].visible = true
			size.y += 20
			page_size += 1
		else:
			command_container[i - page*6].visible = false
	
	if headers.size() < 2:
		size.x = 100
		for i in range(0, 6):
			footnote_label[i].visible = false
	
	size.y += 7
	
	left_page_pointer.position.y = size.y/2 - left_page_pointer.size.y/2
	right_page_pointer.position.y = size.y/2 - left_page_pointer.size.y/2
	
	selected = 0
	pointer.position = pointer_default_pos


func _accept_handler():
	pass
