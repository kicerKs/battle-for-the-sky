class_name WFC

var cells = []
var map = []
var map_size

func prepare():
	prepare_cells()

func get_connections_map(size: Vector2):
	map_size = size
	while not is_pathable():
		map = []
		prepare_map(size)
		while not is_collapsed():
			iterate()
	
	return map

func iterate():
	var coords = get_min_entropy()
	
	#if coords.is_empty():
	#	print("No wyjebało się, trudno, ogarnij żeby mapę na nowo robiło ciołku xDDD")
	collapse_at(coords)
	propagate(coords)

func get_min_entropy():
	var arr = []
	var min_entropy = 100
	for x in map.size():
		for y in map[x].size():
			if map[x][y] is Array:
				if map[x][y].size() > 1 and map[x][y].size() < min_entropy:
					min_entropy = map[x][y].size()
					arr = []
					arr.append(Vector2(x, y))
				elif map[x][y].size() > 1 and map[x][y].size() == min_entropy:
					arr.append(Vector2(x, y))
	if arr.size()>1:
		arr = arr.pick_random()
	elif arr.size()==1:
		arr = arr[0]
	return arr

func collapse_at(coords: Vector2):
	if map[coords.x][coords.y] is Array:
		map[coords.x][coords.y] = map[coords.x][coords.y].pick_random()

func propagate(coords: Vector2):
	var stack = []
	
	stack.append(coords)
	while len(stack) > 0:
		var current_coords = stack.pop_back()
		
		for neighbour in valid_neighbours(current_coords):
			var other_coords = Vector2(current_coords) + Vector2(neighbour)
			if other_coords.x < map_size.x and other_coords.y < map_size.y:

				var other_possibilities = map[int(other_coords.x)][int(other_coords.y)].duplicate()
				
				var possible_neighbours = get_possible_neighbours(current_coords, neighbour)
				
				if len(other_possibilities) == 0 or other_possibilities is Dictionary:
					continue
				for other_possible in other_possibilities:
					if not other_possible in possible_neighbours:
						map[other_coords.x][other_coords.y].erase(other_possible)
						if not other_coords in stack:
							stack.append(other_coords)
							

func get_possible_neighbours(coords, neighbour):
	var side
	var side_n
	if neighbour == Vector2(-1, -1) or (neighbour == Vector2(0, -1) and int(coords.y) % 2 != 0):
		side = "NW"
		side_n = "SE"
	elif neighbour == Vector2(1, -1) or (neighbour == Vector2(0, -1) and int(coords.y) % 2 == 0):
		side = "NE"
		side_n = "SW"
	elif neighbour == Vector2(-1, 0):
		side = "W"
		side_n = "E"
	elif neighbour == Vector2(1, 0):
		side = "E"
		side_n = "W"
	elif (neighbour == Vector2(0, 1) and int(coords.y) % 2 == 0) or neighbour == Vector2(1, 1):
		side = "SE"
		side_n = "NW"
	elif (neighbour == Vector2(0, 1) and int(coords.y) % 2 != 0)  or neighbour == Vector2(-1, 1):
		side = "SW"
		side_n = "NE"
	
	var possibles = cells.duplicate()
	var is_bridge = 0
	var no_bridge = 0
	if map[coords.x][coords.y] is Array:
		for el in len(map[coords.x][coords.y]):
			if map[coords.x][coords.y][el][side] == 0:
				no_bridge += 1
			else:
				is_bridge += 1
		if no_bridge == 0 or is_bridge == 0:
			# Jedna możliwość, czyli zmniejszamy tabelę
			for cell in cells:
				if cell[side_n] != map[coords.x][coords.y][0][side]:
					possibles.erase(cell)
	else:
		for cell in cells:
			if cell[side_n] != map[coords.x][coords.y][side]:
				possibles.erase(cell)
	#var is_bridge = 0
	#var no_bridge = 0
	#if map[coords.x][coords.y] is Array:
	#	for cell in map[coords.x][coords.y]:
	#		if cell[side_n] == 1:
	#			is_bridge += 1
	#		else:
	#			no_bridge += 1
	#	if is_bridge == 0 or no_bridge == 0:
	#		for cell in cells:
	#			if cell[side_n] != map[coords.x][coords.y][side]:
	#				possibles.erase(cell)
	return possibles


func valid_neighbours(coords: Vector2):
	var arr
	if int(coords.y) % 2 == 0: # Is even
		arr = [Vector2(-1, -1), Vector2(0, -1), Vector2(-1, 0), Vector2(1, 0), Vector2(-1, 1), Vector2(0, 1)]
	else:
		arr = [Vector2(1, -1), Vector2(0, -1), Vector2(-1, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)]
	var array = []
	for el in arr:
		var new = coords + el
		if new.x >= 0 and new.y >=0 and new.x < map_size.x and new.y < map_size.y:
			array.append(el)
	return array

func is_collapsed():
	for x in map.size():
		for y in map[x].size():
			if map[x][y].size() > 1 and map[x][y] is Array:
				return false
	return true

func is_pathable():
	if map.is_empty() or !is_collapsed():
		return false
	
	var stack = []
	var visited_nodes = []
	var num_of_visited_nodes = 0
	stack.append(Vector2i(0,0))
	while len(stack) > 0:
		var node = stack.pop_back()
		if node.x >= 0 and node.y >= 0 and node.x < map_size.x and node.y < map_size.y:
			visited_nodes.append(node)
			num_of_visited_nodes += 1
			
			var connections = map[node.x][node.y]
			if connections is Array:
				connections = connections[0]
			if connections["W"] == 1 and node + Vector2i(-1, 0) not in visited_nodes:
				stack.append(node + Vector2i(-1, 0))
			if connections["E"] == 1 and node + Vector2i(1, 0) not in visited_nodes:
				stack.append(node + Vector2i(1, 0))
			if connections["NW"] == 1 and node.y % 2 != 0 and node + Vector2i(0, -1) not in visited_nodes:
				stack.append(node + Vector2i(0, -1))
			if connections["NW"] == 1 and node + Vector2i(-1, -1) not in visited_nodes:
				stack.append(node + Vector2i(-1, -1))
			if connections["SW"] == 1 and node.y % 2 != 0 and node + Vector2i(0, 1) not in visited_nodes:
				stack.append(node + Vector2i(0, 1))
			if connections["SW"] == 1 and node + Vector2i(-1, 1) not in visited_nodes:
				stack.append(node + Vector2i(-1, 1))
			if connections["NE"] == 1 and node + Vector2i(1, -1) not in visited_nodes:
				stack.append(node + Vector2i(1, -1))
			if connections["NE"] == 1 and node.y % 2 == 0 and node + Vector2i(0, -1) not in visited_nodes:
				stack.append(node + Vector2i(0, -1))
			if connections["SE"] == 1 and node.y % 2 == 0 and node + Vector2i(0, 1) not in visited_nodes:
				stack.append(node + Vector2i(0, 1))
			if connections["SE"] == 1 and node + Vector2i(1, 1) not in visited_nodes:
				stack.append(node + Vector2i(1, 1))
	print(visited_nodes)
	if num_of_visited_nodes == (map_size.x+1) * (map_size.y+1):
		return true
	return false

func prepare_map(size):
	map = []
	for x in range(size.x):
		map.append([])
		for y in range(size.y):
			map[x].append(cells.duplicate())
	
	# Boundaries
	
	var new_array = []
	for x in range(size.x):
		new_array.append([])
		for y in range(size.y):
			new_array[x].append(cells.duplicate())
	
	for x in range(size.x):
		for y in range(size.y):
			new_array[x][y] = cells.duplicate()
			if y == 0:
				for key in map[x][y]:
					if key["NW"] == 1 or key["NE"] == 1:
						new_array[x][y].erase(key)
			if y == size.y-1:
				for key in map[x][y]:
					if key["SW"] == 1 or key["SE"] == 1:
						new_array[x][y].erase(key)
			if x == 0:
				for key in map[x][y]:
					if key["W"] == 1:
						new_array[x][y].erase(key)
			if x == size.x-1:
				for key in map[x][y]:
					if key["E"] == 1:
						new_array[x][y].erase(key)
			# Specific for hex map
			if x == 0 and y % 2 == 0:
				for key in map[x][y]:
					if key["NW"] == 1 or key["SW"] == 1:
						new_array[x][y].erase(key)
			if x == size.x-1 and y % 2 != 0:
				for key in map[x][y]:
					if key["NE"] == 1 or key["SE"] == 1:
						new_array[x][y].erase(key)
	map = new_array
	
	# Center
	
	#new_array = []
	#for x in range(size.x):
	#	new_array.append([])
	#for x in range(size.x):
	#	for key in map[x][int(size.y/2)]:
	#		if key["SW"] != key["NE"] or key["SE"] != key["NW"]:
	#			new_array[x][int(size.y/2)].erase(key)
	#for x in range(size.x):
	#	map[x][int(size.y/2)] = new_array[x]

func prepare_cells():
	for i in range(2):
		for j in range(2):
			for k in range(2):
				for l in range(2):
					for m in range(2):
						for n in range(2):
							cells.append({
								"NW": i,
								"NE": j,
								"E": k,
								"SE": l,
								"SW": m,
								"W": n 
							})
	cells.erase({
		"NW": 0,
		"NE": 0,
		"E": 0,
		"SE": 0,
		"SW": 0,
		"W": 0 
	})
