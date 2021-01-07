extends CanvasLayer

var current_selection = 0
var active = false

onready var selectors = [
	$CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer3/HBoxContainer/Selector,
]

func _ready():
	set_current_selection(0)
	set_visible(false)
	var player = get_tree().get_current_scene().get_node("World/Player")
	player.connect("died", self, "_on_Player_died")

func _input(_InputEvent):
	if active:
		if Input.is_action_pressed("ui_down"):
			current_selection = wrapi(current_selection + 1, 0, 3)
			set_current_selection(current_selection)
		elif Input.is_action_pressed("ui_up"):
			current_selection = wrapi(current_selection - 1, 0, 3)
			set_current_selection(current_selection)
		elif Input.is_action_pressed("ui_accept"):
			handle_selection(current_selection)

func handle_selection(_current_selection):
	if active:
		$MenuAccept.play()
	
	match _current_selection:
		0:
			var _er = get_tree().reload_current_scene()
		1:
			Globals.change_scene(load("res://scenes/MainMenu.tscn"))
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

func set_visible(is_visible):
	for node in get_children():
		if node.get("visible"):
			node.visible = is_visible

func _on_Player_died():
	set_current_selection(0)
	active = !active
