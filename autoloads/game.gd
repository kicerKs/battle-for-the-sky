extends Node

# Here everything that needs to be accessed from several places, but is connected with current playthrough, like resources etc.



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
	Resources.WOOD: 100000,
	Resources.FOOD: 100000,
	Resources.STONE: 100000,
	Resources.IRON: 100000,
	Resources.GOLD: 100000
}

func change_player_resource(resource: Resources, amount: int):
	if _player_resources[resource] + amount >= 0:
		_player_resources[resource] += amount
		resources_changed.emit()

func get_player_resource(resource: Resources):
	return _player_resources[resource]
