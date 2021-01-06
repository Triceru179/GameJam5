extends CanvasLayer

var current_selection = 0

onready var selectors = [
	$CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer3/HBoxContainer/Selector,
]

func _ready():
	set_current_selection(0)
	set_visible(false)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_pause_unpause()
	
	if get_tree().paused:
		if event.is_action_pressed("ui_down"):
			current_selection = wrapi(current_selection + 1, 0, 3)
			set_current_selection(current_selection)
		elif event.is_action_pressed("ui_up"):
			current_selection = wrapi(current_selection - 1, 0, 3)
			set_current_selection(current_selection)
		elif event.is_action_pressed("ui_accept"):
			handle_selection(current_selection)

func handle_selection(_current_selection):
	match _current_selection:
		0:
			_pause_unpause()
		1:
			print("Returning to main menu.")
		2:
			get_tree().quit()

func set_current_selection(_current_selection):
	for s in selectors:
		s.text = ""

	for i in range(selectors.size()):
		if _current_selection == i:
			selectors[i].text = ">"

func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible

func _pause_unpause():
	set_current_selection(0)
	set_visible(!get_tree().paused)
	get_tree().paused = !get_tree().paused
