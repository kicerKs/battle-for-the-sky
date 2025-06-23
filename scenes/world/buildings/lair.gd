extends Node2D
class_name Lair

@export var stats: BuildingStats:
	set(value):
		stats = value
		reload()

@onready var sprite = $Sprite2D

func _ready():
	#var xd = $NavigationObstacle2D
	#remove_child(xd)
	#add_child(xd)
	#$Sprite2D.texture = stats.texture
	pass

func can_build():
	if $Area2D.has_overlapping_areas():
		return false
	return true

func get_dict():
	return {
		"position" = self.position
	}

func set_dict(dict):
	self.position = dict["position"]

func reload():
	if has_node("Sprite2D"):
		$Sprite2D.texture = stats.texture

func _on_remove_button_pressed() -> void:
	get_parent().get_parent().remove_building(self)

func get_island() -> Island:
	return Game.tileMapLayer.tiles[Game.tileMapLayer.local_to_map(self.global_position)]
