extends Sprite2D
class_name Island

signal island_conquered

@onready var progress_bar = $CustomProgressBar

var conquering: bool = false
var conquering_time: float = 5.0
var conquering_timer: float = 0.0
var conquering_unit_side: Lobby.Factions

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
	pass

func _process(delta: float) -> void:
	if conquering:
		conquering_timer -= delta
		var progress = 1.0 - (conquering_timer / conquering_time)
		if conquering_timer <= 0:
			stop_conquering()
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

func get_dict():
	return {
		"ownership" = self.ownership
	}

func set_dict(dict):
	self.ownership = dict["ownership"]
	update_sprites()

func set_connections(connections):
	self.connections = connections
	%NavigationBridgeW.enabled = connections["W"]
	%NavigationBridgeSW.enabled = connections["SW"]
	%NavigationBridgeSE.enabled = connections["SE"]
	%NavigationBridgeE.enabled = connections["E"]
	%NavigationBridgeNE.enabled = connections["NE"]
	%NavigationBridgeNW.enabled = connections["NW"]
	update_sprites()

func update_sprites():
	match ownership:
		Lobby.Factions.MONSTERS:
			$Flag.texture = load("res://assets/buildings/flag_neutral.png")
		Lobby.Factions.PLAYER_RED:
			$Flag.texture = load("res://assets/buildings/flag_red.png")
		Lobby.Factions.PLAYER_BLUE:
			$Flag.texture = load("res://assets/buildings/flag_blue.png")
		_:
			$Flag.texture = load("res://assets/buildings/flag_red.png")
	%BridgeSW.visible = connections["SW"]
	%BridgeW.visible = connections["W"]
	%BridgeNW.visible = connections["NW"]
	%BridgeSE.visible = connections["SE"]
	%BridgeE.visible = connections["E"]
	%BridgeNE.visible = connections["NE"]

func add_building(building):
	building.placement_mode = false
	building.position -= self.position
	%MainNavigationRegion.add_child(building)
	%MainNavigationRegion.bake_navigation_polygon()

func start_conquering(unit_side: Lobby.Factions):
	if conquering:
		return
	
	conquering_timer = conquering_time
	conquering_unit_side = unit_side
	progress_bar.visible = true
	conquering = true

func stop_conquering():
	progress_bar.visible = false
	progress_bar.value = 0.0
	
	ownership = conquering_unit_side
	set_dict(self)
	conquering = false
	island_conquered.emit()
