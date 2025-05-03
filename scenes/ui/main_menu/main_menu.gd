extends Control

#frame: BDragon1727
#heart: Art By Nicole Marie T
#sword and shield: Nicat
#font: Daniel Linssen

func _ready():
	Lobby.connect("connection_failed", _show_connection_error_message)
	var window_width = get_viewport().size.x
	var cont = get_child(0)
	for button in cont.get_children():
		if button is Button:
			button.custom_minimum_size.x = window_width /2.5

func _on_single_but_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn");

func _on_multi_but_pressed() -> void:
	%JoiningGameBox.visible = true
	%MainContainer.visible = false

func _on_set_but_pressed() -> void:
	pass # Replace with function body.

func _on_cred_but_pressed() -> void:
	pass

func _on_host_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/lobby_menu/lobby_menu.tscn");
	Lobby.create_game()

func _on_join_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/ui/lobby_menu/lobby_menu.tscn");
	Lobby.join_game(%IPTextEdit.text, int(%PortTextEdit.text))

func _on_cancel_button_pressed() -> void:
	%JoiningGameBox.visible = false
	%MainContainer.visible = true

func _show_connection_error_message():
	%ConnectionMessage.text = "Failed to connect to the server! Check if IP address is valid and try again."
