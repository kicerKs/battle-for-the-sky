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
	wfc.prepare()
	tilemap.clear()
	generate_map(MAP_SIZE.SMALL)
	tilemap.set_generated_connections(wfc.get_connections_map(Vector2(3, 5)))

func generate_map(size: MAP_SIZE):
	var max_coords
	if size == MAP_SIZE.SMALL:
		max_coords = Vector2(3, 5)
	elif size == MAP_SIZE.MEDIUM:
		max_coords = Vector2(4, 6)
	else:
		max_coords = Vector2(6, 8)
	
	for i in range(0, max_coords.x):
		for j in range(0, max_coords.y):
			tilemap.set_cell(Vector2(i, j), 0, Vector2(0, 0), cells[possible_cells.pick_random()])
	#for i in range(max_coords.x, 0, -1):
	#	for j in range(max_coords.y, 0, -1):
	#		tilemap.set_cell(Vector2(i, j), 0, Vector2(0, 0), cells[possible_cells.pick_random()])
	tilemap.update_internals()
