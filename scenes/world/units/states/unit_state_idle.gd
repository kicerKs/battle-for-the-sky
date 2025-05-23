extends UnitState

func on_enter():
	unit.label.text = "Idle"
	owner.animation.play("idle")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click"):
		change_state.emit(MOVING)
