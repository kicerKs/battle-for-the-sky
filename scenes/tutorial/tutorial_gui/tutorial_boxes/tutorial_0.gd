extends PanelContainer


func _on_next_button_pressed() -> void:
	get_parent().current_tutorial += 1

func enable():
	visible = true

func disable():
	visible = false
