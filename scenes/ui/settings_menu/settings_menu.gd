extends Control

func _ready():
	$PanelContainer/VBoxContainer/GridContainer/TextEdit.text = Lobby.player_info["name"]

func _on_text_edit_text_changed(new_text: String) -> void:
	Lobby.player_info["name"] = new_text
	Lobby.save_config()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn");
