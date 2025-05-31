extends UnitState

func on_enter() -> void:
	unit.label.text = "Idle"
	unit.animation.play("idle")
	if unit.current_front == Game.tileMapLayer.local_to_map(unit.position):
		# if player haven't chosen another front, search for another
		unit.auto_front_change.emit(Game.tileMapLayer.local_to_map(unit.position))

func update(delta: float) -> void:
	if unit.current_front != Game.tileMapLayer.local_to_map(unit.position):
		change_state.emit(MOVING)
