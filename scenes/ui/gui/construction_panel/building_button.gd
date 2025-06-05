extends PanelContainer
class_name BuildingButton

signal building_pressed(building)
@export var building: PackedScene
@export var building_stats: BuildingStats

func _ready():
	$Button.icon = building_stats.icon
	$Button.text = building_stats.name

func _on_texture_button_pressed() -> void:
	building_pressed.emit(building)
