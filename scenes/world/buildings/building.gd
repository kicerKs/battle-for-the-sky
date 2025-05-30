extends Node2D
class_name Building

var placement_mode: bool = false
@onready var sprite = $Sprite2D

func _ready():
	var xd = $NavigationObstacle2D
	remove_child(xd)
	add_child(xd)

func _input(_event: InputEvent):
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
