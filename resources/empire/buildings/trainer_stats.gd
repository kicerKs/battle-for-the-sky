extends Resource
class_name TrainerStats

@export var training_time: int = 15
@export var training_cost: Dictionary[Game.Resources, int] = { 
	Game.Resources.WOOD: 0,
	Game.Resources.FOOD: 0,
	Game.Resources.STONE: 0,
	Game.Resources.IRON: 0,
	Game.Resources.GOLD: 0
}
@export var unit: PackedScene
@export var unit_stats: UnitStats
@export var unit_icon: Texture2D
