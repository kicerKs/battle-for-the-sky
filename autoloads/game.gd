extends Node

# Here everything that needs to be accessed from several places, but is connected with current playthrough, like resources etc.

var players = {}
var player_info = {
	"name": "Player",
	"color": IslandDevelopmentData.IslandOwner.PLAYER_RED
}

# Resources
signal resources_changed

enum Resources{
	WOOD,
	FOOD,
	STONE,
	IRON,
	GOLD
}

var _player_resources = {
	Resources.WOOD: 0,
	Resources.FOOD: 0,
	Resources.STONE: 0,
	Resources.IRON: 0,
	Resources.GOLD: 0
}

func change_player_resource(resource: Resources, amount: int):
	if _player_resources[resource] + amount >= 0:
		_player_resources[resource] += amount
		resources_changed.emit()

func get_player_resource(resource: Resources):
	return _player_resources[resource]
