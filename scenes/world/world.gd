extends Node2D

var placement_mode = false
var placement_building

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if placement_mode and event.button_index == MOUSE_BUTTON_RIGHT:
			placement_building.queue_free()
			placement_mode = false
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if placement_building.can_build():
				var target_island = $TileMapLayer.local_to_map(placement_building.position)
				if $TileMapLayer.tiles.has(target_island):
					remove_child(placement_building)
					$TileMapLayer.tiles[target_island].add_building(placement_building)
					placement_mode = false

func building_selected(building):
	if !placement_mode:
		placement_mode = true
		placement_building = building.instantiate()
		placement_building.placement_mode = true
		add_child(placement_building)
