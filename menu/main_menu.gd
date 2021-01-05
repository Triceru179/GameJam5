extends MarginContainer

const FIRST_SCENE = preload("res://menu/FirstScene.tscn")

var current_selection = 0

onready var selectors = [
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Selector,
]

func _ready():
	set_current_selection(0)

func _process(_delta):
	if Input.is_action_just_pressed("action_down"):
		current_selection = wrapi(current_selection + 1, 0, 3)
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("action_up"):
		current_selection = wrapi(current_selection - 1, 0, 3)
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("action_accept"):
		handle_selection(current_selection)

func handle_selection(_current_selection):
	match _current_selection:
		0:
			get_parent().add_child(FIRST_SCENE.instance())
			queue_free()
		1:
			print("Add options!")
		2:
			get_tree().quit()

func set_current_selection(_current_selection):
	for s in selectors:
		s.text = ""
	
	for i in range(selectors.size()):
		if _current_selection == i:
			selectors[i].text = ">"
