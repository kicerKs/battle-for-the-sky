extends PanelContainer

signal building_selected(building)

func _on_building_button_building_pressed(building: Variant) -> void:
	building_selected.emit(building)

func _ready():
	for child in $MarginContainer/HBoxContainer.get_children():
		print(child.building_stats.name)
