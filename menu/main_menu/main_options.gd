extends MarginContainer

export(NodePath) var slider_fx = null
export(NodePath) var slider_music = null

func _ready():
	visible = false
	
	$CenterContainer2/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/Fullscreen/OptionFullscren.pressed = OS.window_fullscreen
	get_node(slider_fx).value = db2linear(AudioServer.get_bus_volume_db(1))
	get_node(slider_music).value = db2linear(AudioServer.get_bus_volume_db(2))

func _process(_delta):
	if visible && Input.is_action_just_pressed("ui_cancel"):
		_return_to_main_menu()

func _adjust_bus_volume(bus, value):
	AudioServer.set_bus_mute(bus, value <= 0)
	if value > 0:
		AudioServer.set_bus_volume_db(bus, linear2db(value))
	
	if visible:
		get_node("MenuAccept").play()

func _return_to_main_menu():
	visible = false
	$MenuAccept.play()
	
	var main_menu = get_parent().get_node("MainMenu")
	main_menu.set_current_selection(0)
	main_menu.visible = true
	main_menu.active = true

func _on_FxSlider_value_changed(value):
	$CenterContainer2/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer4/FxVolume/FxVolume.text = str(int(value * 10))
	_adjust_bus_volume(1, value)

func _on_MusicSlider_value_changed(value):
	$CenterContainer2/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/MusicVolume/MusicVolume.text = str(int(value * 10))
	_adjust_bus_volume(2, value)

func _on_OptionFullscren_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
