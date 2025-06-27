extends Control

func _ready():
	$PanelContainer/VBoxContainer/GridContainer/TextEdit.text = Lobby.player_info["name"]
	SignalBus.config_loaded.connect(setup)
	Lobby.load_config()

func _on_text_edit_text_changed(new_text: String) -> void:
	Lobby.player_info["name"] = new_text
	Lobby.save_config()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn");


func _on_h_slider_value_changed(value: float) -> void:
	AudioManager.music_volume = value


func _on_h_slider_2_value_changed(value: float) -> void:
	AudioManager.sound_volume = value

func setup():
	$PanelContainer/VBoxContainer/GridContainer/HSlider.value = AudioManager.music_volume
	$PanelContainer/VBoxContainer/GridContainer/HSlider2.value = AudioManager.sound_volume
