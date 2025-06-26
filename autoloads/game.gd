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
	Resources.WOOD: 15,
	Resources.FOOD: 10,
	Resources.STONE: 15,
	Resources.IRON: 15,
	Resources.GOLD: 10
}

func change_player_resource(resource: Resources, amount: int):
	if _player_resources[resource] + amount >= 0:
		_player_resources[resource] += amount
		resources_changed.emit()

func get_player_resource(resource: Resources):
	return _player_resources[resource]
