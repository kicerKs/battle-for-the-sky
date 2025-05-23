extends UnitState

func on_enter():
	unit.label.text = "Moving"
	owner.movement_component.start_moving()
	owner.animation.play("walk")

func physics_update(delta: float) -> void:
	unit.movement_component.update_movement(delta)
	unit.move_and_slide()

func update(delta: float) -> void:
	if owner.nav_agent.is_navigation_finished():
		owner.movement_component.intended_velocity = Vector2.ZERO
		change_state.emit(IDLE)
