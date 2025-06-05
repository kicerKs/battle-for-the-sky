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

func _input(event: InputEvent):
	if placement_mode:
		position = get_global_mouse_position()

func can_build(island: Island):
	if $Area2D.has_overlapping_areas():
		return false
	if island.ownership == Lobby.player_info["color"]:
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
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			SignalBus.building_clicked.emit(self)

func _on_remove_button_pressed() -> void:
	queue_free()
