extends Resource
class_name IslandDevelopmentData

enum IslandOwner{
	MONSTERS,
	PLAYER_RED,
	PLAYER_BLUE
}

@export var ownership: IslandOwner
