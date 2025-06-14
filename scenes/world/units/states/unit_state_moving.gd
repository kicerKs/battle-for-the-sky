extends UnitState

var is_at_target_island: bool = false
var timer: float = 2.5

var test_timer: float = 0.2

func on_enter() -> void:
	unit.label.text = "Moving"
	unit.animation.play("walk")
	unit.front_changed.connect(_on_front_changed)
	unit.movement_component.start_moving(Game.tileMapLayer.map_to_local(unit.current_front))
	var arr = %DetectionRange.get_overlapping_bodies()
	for body in arr:
		if body is CharacterBody2D and body != owner and body.side != owner.side:
			change_state.emit(ENGAGE)

func physics_update(delta: float) -> void:
	unit.movement_component.update_movement(delta)
	unit.move_and_slide()

func update(delta: float) -> void:
	test_timer -= delta
	if test_timer <= 0:
		test_timer = 1.0
		var arr = %DetectionRange.get_overlapping_bodies()
		for body in arr:
			if body is CharacterBody2D and body != owner and body.side != owner.side:
				change_state.emit(ENGAGE)
	if Game.tileMapLayer.local_to_map(unit.position) == unit.current_front:
		if is_at_target_island:
			timer -= delta
		else:
			is_at_target_island = true
	if unit.nav_agent.is_navigation_finished() or timer <= 0:
		timer = 2.5
		unit.movement_component.intended_velocity = Vector2.ZERO
		var current_island_side = get_current_island_ownership()
		if current_island_side != unit.side:
			change_state.emit(CONQUERING)
		else:
			change_state.emit(IDLE)

func _on_front_changed(island: Vector2i):
	unit.movement_component.start_moving(Game.tileMapLayer.map_to_local(island))
