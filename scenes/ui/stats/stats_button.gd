extends Button

var file

func setup(filepath):
	file = filepath
	self.text = filepath

func _on_pressed() -> void:
	Global.game_name = file
	get_tree().change_scene_to_file("res://scenes/ui/stats/game_stats.tscn")
