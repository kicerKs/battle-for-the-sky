extends Node

@onready var tilemap = $"../TileMapLayer"

enum MAP_SIZE{
	SMALL,
	MEDIUM,
	LARGE
}

var wfc = WFC.new()
var possible_cells = ["plains", "wood", "food", "stone", "iron", "gold"]
var cells = {
	"plains": 1,
	"food": 2,
	"gold": 3,
	"iron": 4,
	"stone": 5,
	"wood": 6
}

func _ready():
	tilemap.clear()
	if multiplayer.is_server():
		wfc.prepare()
		generate_map(MAP_SIZE.SMALL)
		tilemap.set_generated_connections.rpc(wfc.get_connections_map(Vector2(3, 3)))

func generate_map(size: MAP_SIZE):
	var max_coords
	if size == MAP_SIZE.SMALL:
		max_coords = Vector2(3, 5)
	elif size == MAP_SIZE.MEDIUM:
		max_coords = Vector2(5, 7)
	else:
		max_coords = Vector2(7, 9)
	
	for i in range(0, max_coords.x):
		for j in range(0, int((max_coords.y-1)/2)):
			var cell = cells[possible_cells.pick_random()]
			set_cell.rpc(Vector2(i, j), cell)
			set_cell.rpc(Vector2(i, max_coords.y-j-1), cell)
			#tilemap.set_cell(Vector2(i, j), 0, Vector2(0, 0), cell)
			#tilemap.set_cell(Vector2(i, max_coords.y-j-1), 0, Vector2(0, 0), cell)
		set_cell.rpc(Vector2(i, (max_coords.y-1)/2), cells[possible_cells.pick_random()])
		#tilemap.set_cell(Vector2(i, (max_coords.y-1)/2), 0, Vector2(0, 0), cells[possible_cells.pick_random()])
	reload_tilemap.rpc()
	#tilemap.update_internals()
	
@rpc("call_local", "reliable", "any_peer")
func set_cell(coords, cell):
	tilemap.set_cell(coords, 0, Vector2(0, 0), cell)

@rpc("call_local", "reliable", "any_peer")
func reload_tilemap():
	tilemap.update_internals()
	$"../Camera2D".reset_camera()
