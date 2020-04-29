extends PanelContainer

func _on_PlayerName_text_changed(new_text):
	Settings.playername = new_text


func _on_SoundsSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear2db(value))

func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value))


func _on_Button_pressed():
	$AudioStreamPlayer.play()


func _on_PlayMusic_pressed():
	$"/root/Main/Music".play()
