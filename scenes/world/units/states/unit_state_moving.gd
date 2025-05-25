extends UnitState

func on_enter():
	unit.label.text = "Moving"
	unit.animation.play("walk")
	
	await get_tree().process_frame # must wait 1 frame to assert unit is added to map as child
	var target_island_key = find_nearest_enemy_island(islands_map.local_to_map(unit.position))
	if target_island_key != Vector2i(-1, -1):
		unit.movement_component.start_moving(islands_map.map_to_local(target_island_key))

func physics_update(delta: float) -> void:
	unit.movement_component.update_movement(delta)
	unit.move_and_slide()

func update(delta: float) -> void:
	if unit.nav_agent.is_navigation_finished():
		unit.movement_component.intended_velocity = Vector2.ZERO
		change_state.emit(CONQUERING)

# ################ GRID SEARCH ################
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
				
			# Check if this is a grey or red flag
			if get_island_ownership(neighbor_pos) == 1:
				return neighbor_pos
				
			# Mark as visited and add to queue
			visited[neighbor_pos] = true
			queue.append(neighbor_pos)
	
	return Vector2i(-1, -1)  # Return invalid position if no red flag found
