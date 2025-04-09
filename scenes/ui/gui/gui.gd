extends CanvasLayer

func _ready() -> void:
	var window_width = get_viewport().size.x
	var char_panel = get_node("characterPanel")
	var build_panel = get_node("BuildingPanel")
	#char_panel.custom_minimum_size = Vector2(window_width /2.2,0)
	#build_panel.custom_minimum_size = Vector2(window_width / 2.2,0)
	# test it out whether its a good idea	
