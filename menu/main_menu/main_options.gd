extends MarginContainer

func _on_FxSlider_value_changed(value):
	AudioServer.set_bus_volume_db(1, lerp(AudioServer.get_bus_volume_db(1),  value, 0.5))
	if value == -24:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
		get_node("CenterContainer2/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer4/FxVolume/MenuAccept2").play()


func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(2, lerp(AudioServer.get_bus_volume_db(2),  value, 0.5))
	if value == -24:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
		get_node("CenterContainer2/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer4/FxVolume/MenuAccept2").play()
