extends Node

@export var tilemap: TileMapLayer

func _ready():
	tilemap.connect("map_loaded", _generate_map)

func _generate_map():
	if multiplayer.is_server():
		var islands = tilemap.tiles
		
		# Here map generation stuff should be done - ofc can be in other functions
		# Here is my placeholder for checking if map sending is working
		var red_island_key = islands.keys().pick_random()
		var red_island = islands[red_island_key]
		islands.erase(red_island_key)
		var blue_island_key = islands.keys().pick_random()
		var blue_island = islands[blue_island_key]
		red_island.ownership = Lobby.Factions.PLAYER_RED
		blue_island.ownership = Lobby.Factions.PLAYER_BLUE
		islands[red_island_key] = red_island
		islands[blue_island_key] = blue_island
		
		# Here map is refreshed and sended to all players, if multiplayer
		for key in islands:
			tilemap.set_island_dict.rpc(key, islands[key].get_dict())
