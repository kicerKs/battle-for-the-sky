class_name GeneratorStats
extends Resource

@export var name: String
@export var description: String
@export var generatingTime: int = 15
@export var generatingResources: Dictionary[Game.Resources, int] = { 
	Game.Resources.WOOD: 0,
	Game.Resources.FOOD: 0,
	Game.Resources.STONE: 0,
	Game.Resources.IRON: 0,
	Game.Resources.GOLD: 0
}
@export var first_upgrade_multiplier: float = 1.25
@export var second_upgrade_multiplier: float = 1.5
