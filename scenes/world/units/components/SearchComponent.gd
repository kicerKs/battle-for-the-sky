extends Node
class_name SearchComponent

# Grid search algorithm for nearest enemy island

var hex_directions = [
	Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 1),
	Vector2i(-1, 0), Vector2i(0, -1), Vector2i(1, -1)
]

func find_nearest_enemy_island(current_island: Vector2i) -> Vector2i:
	var visited = {}
	var queue = []
	
	queue.append(current_island)
	visited[current_island] = true
	
	while queue.size() > 0:
		var current_pos = queue.pop_front()
		
		# Check all 6 hexagonal neighbors
		for dir in hex_directions:
			var neighbor_pos = current_pos + dir
			
			# Skip if out of bounds (FIXED VALUES, MUST BE CHANGED LATER)
			if neighbor_pos.x < 0 or neighbor_pos.x >= 5 or neighbor_pos.y < 0 or neighbor_pos.y >= 6:
				continue
				
			# Skip if already visited
			if neighbor_pos in visited:
				continue
				
			# Check if this is a enemy flag
			var island = Game.tileMapLayer.tiles[neighbor_pos]
			if island.ownership != Lobby.Factions.PLAYER_BLUE:
				return neighbor_pos
				
			# Mark as visited and add to queue
			visited[neighbor_pos] = true
			queue.append(neighbor_pos)
	
	return Vector2i(-1, -1)  # Return invalid position if no enemy flag found
