class_name UnitStats
extends Resource

@export var name: String
@export var description: String
@export var level: int = 1
@export var trainingTime: int = 15
@export var trainingResources: Dictionary[Game.Resources, int] = { 
	Game.Resources.WOOD: 0,
	Game.Resources.FOOD: 0,
	Game.Resources.STONE: 0,
	Game.Resources.IRON: 0,
	Game.Resources.GOLD: 0
}
@export var max_hp: int = 100
@export var armor: int = 10
@export var speed: int = 100
@export var range: int = 60 #60 mele a 250 range chyba że zwariowałem taka też jest szansa
@export var singleTarget: bool = true
@export var action: int
@export var actionSpeed: int
