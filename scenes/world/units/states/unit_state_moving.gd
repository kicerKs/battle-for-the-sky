extends UnitState

func on_enter() -> void:
	unit.label.text = "Moving"
	unit.animation.play("walk")
	unit.front_changed.connect(_on_front_changed)
	unit.movement_component.start_moving(islands_map.map_to_local(unit.current_front))

func physics_update(delta: float) -> void:
	unit.movement_component.update_movement(delta)
	unit.move_and_slide()

func update(delta: float) -> void:
	if unit.nav_agent.is_navigation_finished():
		unit.movement_component.intended_velocity = Vector2.ZERO
		var current_island_key = islands_map.local_to_map(unit.position)
		var current_island_side = get_island_ownership(current_island_key)
		if current_island_side == 0 or current_island_side == 1:
			change_state.emit(CONQUERING)
		else:
			change_state.emit(IDLE)

func _on_front_changed(island: Vector2i):
	unit.movement_component.start_moving(islands_map.map_to_local(island))
