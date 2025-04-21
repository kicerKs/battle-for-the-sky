extends CanvasLayer

signal building_selected(building)

func _ready() -> void:
	var window_width = get_viewport().size.x
	var char_panel = get_node("characterPanel")
	var build_panel = get_node("BuildingPanel")
	#char_panel.custom_minimum_size = Vector2(window_width /2.2,0)
	#build_panel.custom_minimum_size = Vector2(window_width / 2.2,0)
	# test it out whether its a good idea	

func _on_construction_panel_building_selected(building: Variant) -> void:
	building_selected.emit(building)
