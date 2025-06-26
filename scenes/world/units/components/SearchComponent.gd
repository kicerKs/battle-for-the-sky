class_name SearchComponent
extends Node

func find_nearest_enemy_island(current_island: Vector2i) -> Vector2i:
	print("Searching on ", multiplayer.get_unique_id())
	var visited = {}
	var queue = []
	
	queue.append(current_island)
	visited[current_island] = true
	
	while queue.size() > 0:
		var current_pos = queue.pop_front()
		print(queue)
		# Get the connections for the current island
		var connections = Game.tileMapLayer.tiles[current_pos].connections
		
		# Check all possible directions based on actual connections
		if connections["E"] == 1:
			var neighbor_pos = current_pos + Vector2i(1, 0)
			print(neighbor_pos)
			if _process_neighbor(neighbor_pos, visited, queue):
				return neighbor_pos
		
		if connections["W"] == 1:
			var neighbor_pos = current_pos + Vector2i(-1, 0)
			print(neighbor_pos)
			if _process_neighbor(neighbor_pos, visited, queue):
				return neighbor_pos
		
		# Handle NW/NE directions based on even/odd row
		if current_pos.y % 2 == 0:
			if connections["NW"] == 1:
				var neighbor_pos = current_pos + Vector2i(0, -1)
				print(neighbor_pos)
				if _process_neighbor(neighbor_pos, visited, queue):
					return neighbor_pos
			if connections["NE"] == 1:
				var neighbor_pos = current_pos + Vector2i(0, -1)
				print(neighbor_pos)
				if _process_neighbor(neighbor_pos, visited, queue):
					return neighbor_pos
			if connections["SW"] == 1:
				var neighbor_pos = current_pos + Vector2i(0, 1)
				print(neighbor_pos)
				if _process_neighbor(neighbor_pos, visited, queue):
					return neighbor_pos
			if connections["SE"] == 1:
				var neighbor_pos = current_pos + Vector2i(0, 1)
				print(neighbor_pos)
				if _process_neighbor(neighbor_pos, visited, queue):
					return neighbor_pos
		else:  # Odd row
			if connections["NW"] == 1:
				var neighbor_pos = current_pos + Vector2i(-1, -1)
				print(neighbor_pos)
				if _process_neighbor(neighbor_pos, visited, queue):
					return neighbor_pos
			if connections["NE"] == 1:
				var neighbor_pos = current_pos + Vector2i(1, -1)
				print(neighbor_pos)
				if _process_neighbor(neighbor_pos, visited, queue):
					return neighbor_pos
			if connections["SW"] == 1:
				var neighbor_pos = current_pos + Vector2i(-1, 1)
				print(neighbor_pos)
				if _process_neighbor(neighbor_pos, visited, queue):
					return neighbor_pos
			if connections["SE"] == 1:
				var neighbor_pos = current_pos + Vector2i(1, 1)
				print(neighbor_pos)
				if _process_neighbor(neighbor_pos, visited, queue):
					return neighbor_pos
	print("NO found")
	return Vector2i(-1, -1)  # Return invalid position if no enemy flag found

func _process_neighbor(neighbor_pos: Vector2i, visited: Dictionary, queue: Array) -> bool:
	# Skip if out of bounds
	print("Process neighbor")
	if neighbor_pos.x < 0 or neighbor_pos.x >= 5 or neighbor_pos.y < 0 or neighbor_pos.y >= 6:
		return false
	print("Process neighbor2")
	# Skip if already visited
	if neighbor_pos in visited:
		return false
	print("Process neighbor3")
	# Check if this is an enemy flag
	var island = Game.tileMapLayer.tiles[neighbor_pos]
	if island.ownership != owner.get_island().ownership:
		return true
	print("Process neighbor4")
	# Mark as visited and add to queue
	visited[neighbor_pos] = true
	queue.append(neighbor_pos)
	print(queue)
	return false
