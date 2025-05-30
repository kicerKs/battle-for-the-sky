extends TileMapLayer

signal map_loaded

var tiles = { }
var loaded_islands = 0

var conquering_time: float = 15.0
var conquering_islands: Array[Vector2i] = []
var conquering_progress_bars: Dictionary[Vector2i, ProgressBar] = {}

func _ready():
	Game.tileMapLayer = self
	connect("child_entered_tree", register_child)
	connect("child_exiting_tree", unregister_child)

func _process(delta: float) -> void:
	for island_key in conquering_islands.duplicate():
		tiles[island_key].conquering_timer -= delta
		var progress = tiles[island_key].conquering_timer / conquering_time
		conquering_progress_bars[island_key].value = progress
		if tiles[island_key].conquering_timer <= 0:
			stop_conquering(island_key)

func register_child(node: Node):
	if node is Island:
		tiles[local_to_map(node.position)] = node
		# Tutaj info z wygenerowanej mapy, wrzucimy to potem może w jeden resource, albo i nie, idk
		#node.init(IslandData.new(), IslandDevelopmentData.IslandOwner.PLAYER_RED)
		loaded_islands+=1
		if loaded_islands == len(get_used_cells()):
			#map_loaded.emit()
			
			# ### FOR OWNERSHIP TESTS ###
			var red_island_key = Vector2i(1, 0)
			var red_island = tiles[red_island_key]
			var blue_island_key = Vector2i(0, 0)
			var blue_island = tiles[blue_island_key]
			red_island.ownership = Lobby.Factions.PLAYER_RED
			blue_island.ownership = Lobby.Factions.PLAYER_BLUE
			tiles[red_island_key] = red_island
			tiles[blue_island_key] = blue_island
			
			# Here map is refreshed and sended to all players, if multiplayer
			for key in tiles:
				set_island_dict.rpc(key, tiles[key].get_dict())
			# ###########################
			
			_set_islands_connections()

func unregister_child(node: Node):
	tiles.erase(local_to_map(node.position))

@rpc("call_local", "reliable")
func set_island_dict(key, dict):
	tiles[key].set_dict(dict)

func _set_islands_connections():
	var keys = tiles.keys()
	for key in tiles.keys():
		var connections = {
			"SW": false,
			"W": false,
			"NW": false,
			"SE": false,
			"E": false,
			"NE": false
		}
		if key.y % 2 == 0:
			if keys.has(key+Vector2i(-1,-1)):
				connections["NW"] = true
			if keys.has(key+Vector2i(0, -1)):
				connections["NE"] = true
			if keys.has(key+Vector2i(-1, 1)):
				connections["SW"] = true
			if keys.has(key+Vector2i(0, 1)):
				connections["SE"] = true
		else:
			if keys.has(key+Vector2i(0, -1)):
				connections["NW"] = true
			if keys.has(key+Vector2i(1, -1)):
				connections["NE"] = true
			if keys.has(key+Vector2i(0, 1)):
				connections["SW"] = true
			if keys.has(key+Vector2i(1, 1)):
				connections["SE"] = true
		if keys.has(key+Vector2i(1, 0)):
			connections["E"] = true
		if keys.has(key+Vector2i(-1, 0)):
			connections["W"] = true
		tiles[key].set_connections(connections)

func start_conquering(unit_position: Vector2, unit_side: Lobby.Factions):
	var island_key = local_to_map(unit_position)
	if conquering_islands.has(island_key):
		return
	
	tiles[island_key].conquering_timer = conquering_time
	tiles[island_key].conquering_unit_side = unit_side
	conquering_islands.append(island_key)
	
	var progress_bar: ProgressBar = ProgressBar.new()
	progress_bar.show_percentage = false
	progress_bar.size = Vector2(250.0, 30.0)
	progress_bar.position = map_to_local(island_key) + Vector2(-125.0, 25.0)
	progress_bar.max_value = 1.0
	progress_bar.value = 1.0
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0, 1, 0)
	style_box.set_corner_radius_all(10)
	progress_bar.add_theme_stylebox_override("fill", style_box)
	progress_bar.add_theme_stylebox_override("bg", style_box.duplicate())
	add_child(progress_bar)
	conquering_progress_bars[island_key] = progress_bar

func stop_conquering(island_key: Vector2i):
	if conquering_progress_bars.has(island_key):
		conquering_progress_bars[island_key].queue_free()
		conquering_progress_bars.erase(island_key)
	
	conquering_islands.erase(island_key)
	
	var island = tiles[island_key]
	island.ownership = island.conquering_unit_side
	tiles[island_key] = island
	
	for key in tiles:
		set_island_dict.rpc(key, tiles[key].get_dict())
