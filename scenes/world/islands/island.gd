extends Sprite2D
class_name Island

@export var building_limit: int = 4
@export var resources_modifier = {
	Game.Resources.WOOD: 1.0,
	Game.Resources.FOOD: 1.0,
	Game.Resources.STONE: 1.0,
	Game.Resources.GOLD: 1.0,
	Game.Resources.IRON: 1.0
}

var unit_count = {
	Lobby.Factions.MONSTERS: 0,
	Lobby.Factions.PLAYER_RED: 0,
	Lobby.Factions.PLAYER_BLUE: 0,
	Lobby.Factions.PLAYER_GREEN: 0,
	Lobby.Factions.PLAYER_PURPLE: 0
}

signal island_conquered
signal conquering_interrupted

@onready var progress_bar = $CustomProgressBar

@export var buildings_number = 0:
	get:
		return %MainNavigationRegion.get_child_count()

var conquering: bool = false
var conquering_time: float = 5.0
var conquering_timer: float = 5.0
var conquering_unit_side: Lobby.Factions

@export var progress: float

@export var island_data: IslandData
var ownership: Lobby.Factions
var connections = {
	"SW": false,
	"W": false,
	"NW": false,
	"SE": false,
	"E": false,
	"NE": false
}

func _ready():
	$MultiplayerSynchronizer.synchronized.connect(sync_conquering_bar)

func _process(delta: float) -> void:
	if conquering:
		if !can_conquer(conquering_unit_side):
			conquering = false
			print("Conquering interrupted!")
			conquering_interrupted.emit()
		conquering_timer -= delta
		progress = 1.0 - (conquering_timer / conquering_time)
		if conquering_timer <= 0:
			stop_conquering()
		progress_bar.value = progress
	else:
		if !has_enemy():
			conquering_timer += delta
			progress = 1.0 - (conquering_timer / conquering_time)
			if conquering_timer >= conquering_time:
				conquering_failed()
			progress_bar.value = progress

#func init(data: IslandData = IslandData.new(), owner: IslandDevelopmentData.IslandOwner = IslandDevelopmentData.IslandOwner.MONSTERS):
#	island_development_data = IslandDevelopmentData.new()
#	island_development_data.ownership = owner
#	update_sprites()

func get_island_polygon():
	var polygon = %MainNavigationRegion.navigation_polygon.get_vertices()
	var return_polygon: PackedVector2Array
	for el in polygon:
		return_polygon.append(el + position)
	return return_polygon

func get_resource_bonus(resource: Game.Resources):
	return resources_modifier[resource]

func get_dict():
	return {
		"ownership" = self.ownership
	}

@rpc("call_local", "any_peer", "reliable")
func set_dict(dict):
	self.ownership = dict["ownership"]
	update_sprites()

func set_connections(connections):
	if connections is Array:
		connections = connections[0]
	self.connections = connections
	%NavigationBridgeW.enabled = connections["W"]
	%NavigationBridgeSW.enabled = connections["SW"]
	%NavigationBridgeSE.enabled = connections["SE"]
	%NavigationBridgeE.enabled = connections["E"]
	%NavigationBridgeNE.enabled = connections["NE"]
	%NavigationBridgeNW.enabled = connections["NW"]
	update_sprites()

func update_sprites():
	buildings_number = %MainNavigationRegion.get_child_count()
	match ownership:
		Lobby.Factions.MONSTERS:
			$Flag.texture = load("res://assets/buildings/flag_neutral.png")
		Lobby.Factions.PLAYER_RED:
			$Flag.texture = load("res://assets/buildings/flag_red.png")
		Lobby.Factions.PLAYER_BLUE:
			$Flag.texture = load("res://assets/buildings/flag_blue.png")
		Lobby.Factions.PLAYER_PURPLE:
			$Flag.texture = load("res://assets/buildings/flag_purple.png")
		Lobby.Factions.PLAYER_GREEN:
			$Flag.texture = load("res://assets/buildings/flag_green.png")
		_:
			$Flag.texture = load("res://assets/buildings/flag_red.png")
	%BridgeSW.visible = connections["SW"]
	%BridgeW.visible = connections["W"]
	%BridgeNW.visible = connections["NW"]
	%BridgeSE.visible = connections["SE"]
	%BridgeE.visible = connections["E"]
	%BridgeNE.visible = connections["NE"]
	
	%BuildingLimitLabel.text = str(buildings_number) + "/" + str(building_limit)
	%IslandBonusIcon.visible = true
	%IslandBonusLabel.visible = true
	if resources_modifier[Game.Resources.WOOD] > 1.0:
		%IslandBonusIcon.texture = load("res://assets/resources/wood.png")
		%IslandBonusLabel.text = "+"+str((resources_modifier[Game.Resources.WOOD]-1.0)*100)+"%"
	elif resources_modifier[Game.Resources.FOOD] > 1.0:
		%IslandBonusIcon.texture = load("res://assets/resources/food.png")
		%IslandBonusLabel.text = "+"+str((resources_modifier[Game.Resources.FOOD]-1.0)*100)+"%"
	elif resources_modifier[Game.Resources.STONE] > 1.0:
		%IslandBonusIcon.texture = load("res://assets/resources/stone.png")
		%IslandBonusLabel.text = "+"+str((resources_modifier[Game.Resources.STONE]-1.0)*100)+"%"
	elif resources_modifier[Game.Resources.IRON] > 1.0:
		%IslandBonusIcon.texture = load("res://assets/resources/iron.png")
		%IslandBonusLabel.text = "+"+str((resources_modifier[Game.Resources.IRON]-1.0)*100)+"%"
	elif resources_modifier[Game.Resources.GOLD] > 1.0:
		%IslandBonusIcon.texture = load("res://assets/resources/gold.png")
		%IslandBonusLabel.text = "+"+str((resources_modifier[Game.Resources.GOLD]-1.0)*100)+"%"
	else:
		%IslandBonusIcon.visible = false
		%IslandBonusLabel.visible = false

func add_building(building):
	if building is Building:
		building.placement_mode = false
		SignalBus.building_built.emit(ownership)
	building.position -= self.position
	%MainNavigationRegion.add_child(building)
	%MainNavigationRegion.bake_navigation_polygon()
	buildings_number = %MainNavigationRegion.get_child_count()
	update_sprites()

var remove_scene = load("res://scenes/world/projectiles/remove_building.tscn")

func remove_building(building):
	setup_remove_scene.rpc(building.position)
	building.remove.rpc()
	#building.queue_free()
	%MainNavigationRegion.bake_navigation_polygon()
	buildings_number = %MainNavigationRegion.get_child_count()
	update_sprites()

@rpc("any_peer", "call_local", "reliable")
func setup_remove_scene(pos):
	if multiplayer.is_server():
		buildings_number = %MainNavigationRegion.get_child_count()
	var remove_scene_inst = remove_scene.instantiate()
	remove_scene_inst.position = pos
	add_child(remove_scene_inst)

func start_conquering(unit_side: Lobby.Factions):
	if conquering or !can_conquer(unit_side):
		return
	if conquering_timer <= 0:
		conquering_timer = conquering_time
	conquering_unit_side = unit_side
	conquering = true
	show_conquering_bar.rpc()

@rpc("call_local", "any_peer", "reliable")
func show_conquering_bar():
	progress_bar.visible = true

func conquering_failed():
	hide_conquering_bar.rpc()
	conquering_timer = conquering_time
	progress_bar.value = 0.0
	conquering = false

func stop_conquering():
	hide_conquering_bar.rpc()
	remove_all_buildings.rpc()
	conquering_time = 0
	progress_bar.value = 0.0
	SignalBus.island_conquered.emit(ownership, conquering_unit_side)
	ownership = conquering_unit_side
	set_dict.rpc(get_dict())
	conquering = false
	island_conquered.emit()

@rpc("call_local", "reliable", "any_peer")
func hide_conquering_bar():
	progress_bar.visible = false

@rpc("call_local", "any_peer", "reliable")
func remove_all_buildings():
	for node in %MainNavigationRegion.get_children():
		if node is Building or node is Lair:
			remove_building(node)

func sync_conquering_bar():
	progress_bar.value = progress

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TestCharacter or body is TestMonster:
		unit_count[body.side] += 1

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is TestCharacter or body is TestMonster:
		unit_count[body.side] -= 1

func can_conquer(side):
	for key in unit_count.keys():
		if unit_count[key] > 0 and key != side:
			return false
	return true

func has_enemy():
	for key in unit_count.keys():
		if unit_count[key] > 0 and key != ownership:
			return true
	return false

func is_conquering():
	return conquering
