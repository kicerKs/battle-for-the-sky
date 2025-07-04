extends Node2D

var placement_mode = false
var placement_building
var building_path

static var i = 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if placement_mode:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				SignalBus.hide_resource_cost.emit()
				placement_building.queue_free()
				placement_mode = false
			elif event.button_index == MOUSE_BUTTON_LEFT:
				if Game.tileMapLayer.local_to_map(placement_building.position) in Game.tileMapLayer.tiles:
					if placement_building.can_build($TileMapLayer.tiles[Game.tileMapLayer.local_to_map(placement_building.position)]):
						var target_island = Game.tileMapLayer.local_to_map(placement_building.position)
						if Game.tileMapLayer.tiles.has(target_island):
							SignalBus.hide_resource_cost.emit()
							SignalBus.hide_panels.emit()
							remove_child(placement_building)
							for res in placement_building.stats.cost.keys():
								Game.change_player_resource(res, -placement_building.stats.cost[res])
							add_building.rpc(target_island, building_path, placement_building.get_dict(), i)
							placement_mode = false

func _ready():
	Game.world = $VFX
	

func _process(delta: float) -> void:
	if placement_mode:
		update_visual_feedback()

# Color visuals for player if the building can be placed
func update_visual_feedback():
	if placement_building.sprite:
		var target_island = Game.tileMapLayer.local_to_map(placement_building.position)
		if Game.tileMapLayer.tiles.has(target_island):
			if placement_building.can_build($TileMapLayer.tiles[target_island]):
				placement_building.sprite.modulate = Color(0.5, 1, 0.5)  # Light green
			else:
				placement_building.sprite.modulate = Color(1, 0.5, 0.5)  # Light red
		else:
			placement_building.sprite.modulate = Color(1, 0.5, 0.5)  # Light red

func building_selected(building):
	if placement_mode:
		placement_building.queue_free()
	
	building_path = building.resource_path
	placement_mode = true
	placement_building = building.instantiate()
	placement_building.placement_mode = true
	SignalBus.show_resource_cost.emit(placement_building.stats.cost)
	placement_building.position = get_global_mouse_position()
	add_child(placement_building)

@rpc("any_peer", "call_local", "reliable")
func add_building(target_island, scene_path, building_dict, number):
	var building = load(scene_path).instantiate()
	building.name = "Building"+str(number)
	i = number + 1
	building.set_dict(building_dict)
	building.start_animation()
	Game.tileMapLayer.tiles[target_island].add_building(building)
	if building is not Lair:
		building.play_sound()
	if multiplayer.is_server():
		activate_building(building, target_island)
	

# Building starts to work after placed on map
func activate_building(building, target_island):
	if building.has_node("TrainComponent"):
		var train_component = building.get_node("TrainComponent")
		train_component.island_key = target_island
		if building is Building:
			train_component.current_front = target_island
		train_component.island_ownership = Game.tileMapLayer.tiles[target_island].ownership
		train_component.activate()
	if building.has_node("GeneratorComponent"):
		building.get_node("GeneratorComponent").activate()
