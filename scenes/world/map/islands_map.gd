extends TileMapLayer

signal map_loaded

var tiles = { }
var loaded_islands = 0

func _ready():
	connect("child_entered_tree", register_child)
	connect("child_exiting_tree", unregister_child)

func register_child(node: Node):
	tiles[local_to_map(node.position)] = node
	# Tutaj info z wygenerowanej mapy, wrzucimy to potem może w jeden resource, albo i nie, idk
	#node.init(IslandData.new(), IslandDevelopmentData.IslandOwner.PLAYER_RED)
	loaded_islands+=1
	if loaded_islands == len(get_used_cells()):
		map_loaded.emit()
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
