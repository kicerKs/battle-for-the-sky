extends Resource
class_name BuildingStats

@export var name: String
@export var description: String
@export var is_upgraded: bool = false
@export var texture: Texture2D
@export var icon: Texture2D
@export var cost: Dictionary[Game.Resources, int] = { 
	Game.Resources.WOOD: 0,
	Game.Resources.FOOD: 0,
	Game.Resources.STONE: 0,
	Game.Resources.IRON: 0,
	Game.Resources.GOLD: 0
}
