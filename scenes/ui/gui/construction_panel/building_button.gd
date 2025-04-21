extends PanelContainer
class_name BuildingButton

signal building_pressed(building)
@export var building: PackedScene
@export var icon: Texture

func _ready():
	$Button.icon = icon

func _on_texture_button_pressed() -> void:
	building_pressed.emit(building)
