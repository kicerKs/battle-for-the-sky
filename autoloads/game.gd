extends Node

# Here everything that needs to be accessed from several places, but is connected with current playthrough, like resources etc.

var tileMapLayer: TileMapLayer
var world: Node2D
var camera: Camera2D

# Resources
signal resources_changed

enum MAP_SIZE{
	SMALL,
	MEDIUM,
	LARGE
}

var map_size = MAP_SIZE.SMALL

enum Resources{
	WOOD,
	FOOD,
	STONE,
	IRON,
	GOLD
}

var _player_resources = {
	Resources.WOOD: 5,
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
