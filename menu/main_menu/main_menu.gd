extends MarginContainer

var current_selection = 0
var active = false

onready var selectors = [
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/Start/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/Options/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/Exit/Selector,
]

func _ready():
	set_current_selection(0)
	active = true
	visible = true

func _process(_delta):
	if !active:
		return
	
	if Input.is_action_just_pressed("ui_down"):
		current_selection = wrapi(current_selection + 1, 0, 3)
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up"):
		current_selection = wrapi(current_selection - 1, 0, 3)
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)

func handle_selection(_current_selection):
	if active:
		$MenuAccept.play()
	
	match _current_selection:
		0:
			active = false
			Globals.change_scene(load("res://scenes/Introduction.tscn"))
		1:
			active = false
			visible = false
			get_parent().get_node("OptionsMenu").visible = true
		2:
			get_tree().quit()

func set_current_selection(_current_selection):
	if active:
		$MenuSelect.play()
	
	for s in selectors:
		s.text = ""
	
	for i in range(selectors.size()):
		if _current_selection == i:
			selectors[i].text = ">"
