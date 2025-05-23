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

func _process(delta: float) -> void:
	if placement_mode:
		update_visual_feedback()

# Color visuals for player if the building can be placed
func update_visual_feedback():
	if placement_building.sprite:
		var target_island = $TileMapLayer.local_to_map(placement_building.position)
		if placement_building.can_build() and $TileMapLayer.tiles.has(target_island):
			placement_building.sprite.modulate = Color(0.5, 1, 0.5)  # Light green
		else:
			placement_building.sprite.modulate = Color(1, 0.5, 0.5)  # Light red

func building_selected(building):
	if placement_mode:
		placement_building.queue_free()
	
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
	activate_building(building)
	$TileMapLayer.tiles[target_island].add_building(building)

# Building starts to work after placed on map
func activate_building(building):
	if building.has_node("TrainComponent"):
		building.get_node("TrainComponent").activate()
	if building.has_node("GeneratorComponent"):
		building.get_node("GeneratorComponent").activate()
