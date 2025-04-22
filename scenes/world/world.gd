extends Node2D

var placement_mode = false
var placement_building
var building_path

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if placement_mode:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				placement_building.queue_free()
				placement_mode = false
			elif event.button_index == MOUSE_BUTTON_LEFT:
				if placement_building.can_build():
					var target_island = $TileMapLayer.local_to_map(placement_building.position)
					if $TileMapLayer.tiles.has(target_island):
						remove_child(placement_building)
						add_building.rpc(target_island, building_path, placement_building.get_dict())
						placement_mode = false

func building_selected(building):
	if !placement_mode:
		building_path = building.resource_path
		placement_mode = true
		placement_building = building.instantiate()
		placement_building.placement_mode = true
		placement_building.position = get_global_mouse_position()
		add_child(placement_building)

@rpc("any_peer", "call_local", "reliable")
func add_building(target_island, scene_path, building_dict):
	var building = load(scene_path).instantiate()
	building.set_dict(building_dict)
	$TileMapLayer.tiles[target_island].add_building(building)
