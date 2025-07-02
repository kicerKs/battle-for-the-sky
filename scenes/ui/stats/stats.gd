extends Control

var button = load("res://scenes/ui/stats/stats_button.tscn")

func _ready() -> void:
	var dir := DirAccess.open("user://stats")
	dir.list_dir_begin()
	for file: String in dir.get_files():
		var but = button.instantiate()
		but.setup(file)
		%ButtonsContainer.add_child(but)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn");
