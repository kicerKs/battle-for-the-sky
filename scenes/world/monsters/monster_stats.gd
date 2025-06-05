extends Resource
class_name MonsterStats

@export var name: String
@export var description: String
@export var spriteSheet: Texture2D
@export var max_hp: int = 100
@export var armor: int = 10
@export var speed: int = 100
@export var range: int = 60 #60 mele a 250 range chyba że zwariowałem taka też jest szansa
@export var singleTarget: bool = true
@export var action: int
@export var actionSpeed: int
@export var icon: Texture2D

var maximum_melee_range = 60
