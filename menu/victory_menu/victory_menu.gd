extends CanvasLayer

var current_selection = 0

onready var selectors = [
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer2/Selector,
]

func _ready():
	MusicPlayer.change_playlist([load("res://songs/Komiku_-_Poupis_incredible_adventures__-_70_Ending_4.ogg")])
	set_current_selection(0)
	set_visible(true)

func _process(_delta):
		if Input.is_action_just_pressed("ui_down"):
			current_selection = wrapi(current_selection + 1, 0, 2)
			set_current_selection(current_selection)
		elif Input.is_action_just_pressed("ui_up"):
			current_selection = wrapi(current_selection - 1, 0, 2)
			set_current_selection(current_selection)
		elif Input.is_action_just_pressed("ui_accept"):
			handle_selection(current_selection)

func handle_selection(_current_selection):
	$MenuAccept.play()
	
	match _current_selection:
		0:
			Globals.call_deferred("change_scene", load("res://scenes/MainMenu.tscn"))
		1:
			get_tree().quit()

func set_current_selection(_current_selection):
	$MenuSelect.play()
	
	for s in selectors:
		s.text = ""

	for i in range(selectors.size()):
		if _current_selection == i:
			selectors[i].text = ">"

func set_visible(is_visible):
	for node in get_children():
		if node.get_indexed("visible") != null:
			node.visible = is_visible
