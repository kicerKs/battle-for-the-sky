extends UnitState

func on_enter() -> void:
	unit.label.text = "Attacking"
	unit.animation.play("attack")

func update(delta: float) -> void:
	# if no enemy nearby
		if state_machine.previous_state_name == CONQUERING:
			change_state.emit(CONQUERING)
		if state_machine.previous_state_name == MOVING:
			change_state.emit(MOVING)
