extends Node2D
class_name Building

@export var stats: BuildingStats:
	set(value):
		stats = value
		reload()

var placement_mode: bool = false
@onready var sprite = $Sprite2D

func _ready():
	var xd = $NavigationObstacle2D
	remove_child(xd)
	add_child(xd)
	$Sprite2D.texture = stats.texture
	SignalBus.connect("panels_closed", hide_buttons)

func _input(event: InputEvent):
	if placement_mode:
		position = get_global_mouse_position()

func can_build(island: Island):
	if $Area2D.has_overlapping_areas():
		return false
	if island.ownership == Lobby.player_info["color"] and island.buildings_number < island.building_limit:
		return true
	return false

func get_dict():
	return {
		"position" = self.position
	}

func set_dict(dict):
	self.position = dict["position"]

func reload():
	if has_node("Sprite2D"):
		$Sprite2D.texture = stats.texture


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and !placement_mode:
		if event.button_index == MOUSE_BUTTON_LEFT:
			SignalBus.building_clicked.emit(self)
			if get_island().ownership == Lobby.player_info["color"]:
				show_buttons()

func _on_remove_button_pressed() -> void:
	SignalBus.hide_panels.emit()
	get_parent().get_parent().remove_building(self)

func show_buttons():
	$Buttons.visible = true

func hide_buttons():
	$Buttons.visible = false
	if has_node("TrainComponent"):
		get_node("TrainComponent").front_change_mode = false

func get_island() -> Island:
	return Game.tileMapLayer.tiles[Game.tileMapLayer.local_to_map(self.global_position)]
