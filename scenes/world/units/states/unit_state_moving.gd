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
		if body is CharacterBody2D and body != owner and ((body.side != owner.side and owner.has_node("Components/AttackComponent")) or (body.side == owner.side and owner.has_node("Components/HealComponent") and !body.health_component.is_max_hp())):
			change_state.emit(ENGAGE)
	
	var current_island_side = get_current_island_ownership()
	if current_island_side != unit.side and can_current_island_be_conquered():
		change_state.emit(CONQUERING)

func physics_update(delta: float) -> void:
	unit.movement_component.update_movement(delta)
	unit.move_and_slide()

func update(delta: float) -> void:
	test_timer -= delta
	if test_timer <= 0:
		test_timer = 1.0
		var arr = %DetectionRange.get_overlapping_bodies()
		for body in arr:
			if body is CharacterBody2D and body != owner and ((body.side != owner.side and owner.has_node("Components/AttackComponent")) or (body.side == owner.side and owner.has_node("Components/HealComponent") and !body.health_component.is_max_hp())):
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
		if current_island_side != unit.side and can_current_island_be_conquered():
			change_state.emit(CONQUERING)
		elif unit.nav_agent.is_navigation_finished():
			change_state.emit(IDLE)

func _on_front_changed(island: Vector2i):
	unit.movement_component.start_moving(Game.tileMapLayer.map_to_local(island))
