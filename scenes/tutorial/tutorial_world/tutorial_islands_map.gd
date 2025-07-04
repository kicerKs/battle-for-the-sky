extends TileMapLayer

signal map_loaded

var tiles = { }
var loaded_islands = 0

var starting_islands = { }

var lairs = {
	"GoblinTent": "res://resources/monsters/buildings/goblin_tent/goblin_tent.tscn",
	"CyclopsCave": "res://resources/monsters/buildings/cyclops_cave/cyclops_cave.tscn",
	"BeholderPortal": "res://resources/monsters/buildings/beholder_portal/beholder_portal.tscn"
}

func _ready():
	Game.tileMapLayer = self
	connect("child_entered_tree", register_child)
	connect("child_exiting_tree", unregister_child)

func register_child(node: Node):
	node.name = "Island"+str(local_to_map(node.position))
	tiles[local_to_map(node.position)] = node
	# Tutaj info z wygenerowanej mapy, wrzucimy to potem może w jeden resource, albo i nie, idk
	#node.init(IslandData.new(), IslandDevelopmentData.IslandOwner.PLAYER_RED)
	loaded_islands+=1
	if multiplayer.is_server():
		tiles[local_to_map(node.position)].connect("island_conquered", check_for_endgame)
	if loaded_islands == len(get_used_cells()):
		#map_loaded.emit()
		if multiplayer.is_server():
			# ### SET OWNERSHIP ###
			var last_island_x = get_used_rect().size.x-1
			var last_island_y = get_used_rect().size.y-1
			
			var red_island_key = Vector2i(0, 0)
			var red_island = tiles[red_island_key]
			red_island.ownership = Lobby.Factions.PLAYER_RED
			tiles[red_island_key] = red_island
			set_starting_islands.rpc(red_island_key, Lobby.Factions.PLAYER_RED)
			
			if len(Lobby.players) > 1:
				var blue_island_key = Vector2i(0, last_island_y)
				var blue_island = tiles[blue_island_key]
				blue_island.ownership = Lobby.Factions.PLAYER_BLUE
				tiles[blue_island_key] = blue_island
				set_starting_islands.rpc(blue_island_key, Lobby.Factions.PLAYER_BLUE)
			
			if len(Lobby.players) > 2:
				var purple_island_key = Vector2i(last_island_x, 0)
				var purple_island = tiles[purple_island_key]
				purple_island.ownership = Lobby.Factions.PLAYER_PURPLE
				tiles[purple_island_key] = purple_island
				set_starting_islands.rpc(purple_island_key, Lobby.Factions.PLAYER_PURPLE)
			
			if len(Lobby.players) > 3:
				var green_island_key = Vector2i(last_island_x, last_island_y)
				var green_island = tiles[green_island_key]
				green_island.ownership = Lobby.Factions.PLAYER_GREEN
				tiles[green_island_key] = green_island
				set_starting_islands.rpc(green_island_key, Lobby.Factions.PLAYER_GREEN)
			
			setup_camera.rpc()
			
			# ### ADD LAIRS HERE ###
			
			
			add_lairs()
			
			tiles[Vector2i(0,0)].connections = {
				"SW": 0,
				"W": 0,
				"NW": 0,
				"SE": 0,
				"E": 1,
				"NE": 0
			}
			tiles[Vector2i(1,0)].connections = {
				"SW": 0,
				"W": 1,
				"NW": 0,
				"SE": 0,
				"E": 1,
				"NE": 0
			}
			tiles[Vector2i(2,0)].connections = {
				"SW": 0,
				"W": 1,
				"NW": 0,
				"SE": 0,
				"E": 0,
				"NE": 0
			}
			
			# Here map is refreshed and sended to all players, if multiplayer
			for key in tiles:
				set_island_dict.rpc(key, tiles[key].get_dict())
			# ###########################

@rpc("any_peer", "call_local", "reliable")
func set_starting_islands(key, color):
	starting_islands[color] = key
	#starting_islands[Lobby.Factions.PLAYER_RED] = r_key
	#starting_islands[Lobby.Factions.PLAYER_BLUE] = b_key

@rpc("any_peer", "call_local", "reliable")
func setup_camera():
	if Game.camera != null:
		Game.camera.setup_camera()

func add_lairs():
	# Ogólnie to kolizje są aktualizowane dopiero w process_frame, więc z poziomu _ready nie można wykryć kolizji za pomocą Area2D.get_overlapping_areas().
	# Trzeba to zrobić ręcznie za pomocą serwera fizyki. To też tu jest zrobione, dlatego to wygląda tak paskudnie xDDDDDDD
	
	var island_size = Game.tileMapLayer.tile_set.tile_size / 3
	var i = 1
	for key in tiles:
		if tiles[key].ownership == Lobby.Factions.MONSTERS:
			var num_of_lairs = 1
			var added_lairs = 0
			while added_lairs < num_of_lairs:
				var lair_scene =  lairs[lairs.keys()[i]]
				i -= 1
				var lair = load(lair_scene).instantiate()
				var island_position = Game.tileMapLayer.map_to_local(key)
				lair.global_position = island_position + Vector2(randi_range(-island_size.x, island_size.x), randi_range(-island_size.y, island_size.y))
				$"..".add_child(lair)
				
				var space_state = get_world_2d().direct_space_state
				var query = PhysicsShapeQueryParameters2D.new()
				query.collide_with_areas = true
				query.shape_rid = lair.get_node("Area2D").get_node("CollisionShape2D").shape.get_rid()
				query.transform = lair.get_node("Area2D").get_node("CollisionShape2D").get_global_transform()
				
				var collisions = space_state.intersect_shape(query)
				
				while !collisions.is_empty():
					lair.global_position = island_position + Vector2(randi_range(-island_size.x, island_size.x), randi_range(-island_size.y, island_size.y))
					space_state = get_world_2d().direct_space_state
					query = PhysicsShapeQueryParameters2D.new()
					query.collide_with_areas = true
					query.shape = lair.get_node("Area2D").get_node("CollisionShape2D").shape
					var transforms = lair.get_node("Area2D").get_node("CollisionShape2D").get_global_transform()
					transforms[2] = lair.global_position
					query.transform = transforms
					collisions = space_state.intersect_shape(query)
					
				$"..".remove_child(lair)
				$"..".add_building.rpc(key, lair_scene, lair.get_dict(), added_lairs)
				#tiles[key].add_building(lair)
				added_lairs += 1

func unregister_child(node: Node):
	tiles.erase(local_to_map(node.position))

@rpc("call_local", "reliable")
func set_island_dict(key, dict):
	tiles[key].set_dict(dict)

@rpc("call_local", "reliable", "any_peer")
func set_generated_connections(connections):
	var last_cell_id = get_used_rect().size - Vector2i(1, 1)
	for x in range(len(connections)):
		for y in range(len(connections[x])):
			var con = connections[x][y]
			if con is Array:
				con = con[0]
			tiles[Vector2i(x, y)].set_connections(connections[x][y])
			var reverse_connections = {
				"SW": false,
				"W": false,
				"NW": false,
				"SE": false,
				"E": false,
				"NE": false
			}
			reverse_connections["SW"] = con["NW"]
			reverse_connections["SE"] = con["NE"]
			reverse_connections["NW"] = con["SW"]
			reverse_connections["NE"] = con["SE"]
			reverse_connections["W"] = con["W"]
			reverse_connections["E"] = con["E"]
			tiles[Vector2i(x, last_cell_id.y-y)].set_connections(reverse_connections)
		var middle_connections = connections[x][last_cell_id.y/2]
		if middle_connections is Array:
			middle_connections = middle_connections[0]
		if middle_connections["SW"] == 1:
			middle_connections["NW"] = 1
		if middle_connections["SE"] == 1:
			middle_connections["NE"] = 1
		if middle_connections["NE"] == 1:
			middle_connections["SE"] = 1
		if middle_connections["NW"] == 1:
			middle_connections["SW"] = 1
		
		#if middle_connections["W"] == 1:
		#	middle_connections["E"] = 1
		#if middle_connections["E"] == 1:
		#	middle_connections["W"] = 1
		tiles[Vector2i(x, last_cell_id.y/2)].set_connections(middle_connections)

func check_for_endgame():
	var remaining_islands = {
		Lobby.Factions.PLAYER_RED: 0,
		Lobby.Factions.PLAYER_BLUE: 0,
		Lobby.Factions.PLAYER_GREEN: 0,
		Lobby.Factions.PLAYER_PURPLE: 0
	}
	var still_in_game = []
	for key in tiles.keys():
		if tiles[key].ownership != Lobby.Factions.MONSTERS:
			remaining_islands[tiles[key].ownership] += 1
	
	#elo, przegrałes, ale dam ci to tylko raz xd
	for key in Lobby.players.keys():
		if remaining_islands[Lobby.players[key]["color"]] == 0 and Lobby.players[key]["in_game"]:
			Lobby.players[key]["in_game"] = false
			player_eliminated.rpc(key)
		elif remaining_islands[Lobby.players[key]["color"]] > 0:
			still_in_game.append(key)
	
	if len(still_in_game) == 1:
		player_won.rpc(still_in_game[0])

@rpc("call_local", "reliable", "any_peer")
func player_eliminated(key):
	SignalBus.player_eliminated.emit(key)

@rpc("call_local", "reliable", "any_peer")
func player_won(key):
	SignalBus.player_won.emit(key)
