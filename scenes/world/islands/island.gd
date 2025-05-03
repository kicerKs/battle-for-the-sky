extends Sprite2D
class_name Island

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

#func init(data: IslandData = IslandData.new(), owner: IslandDevelopmentData.IslandOwner = IslandDevelopmentData.IslandOwner.MONSTERS):
#	island_development_data = IslandDevelopmentData.new()
#	island_development_data.ownership = owner
#	update_sprites()

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
