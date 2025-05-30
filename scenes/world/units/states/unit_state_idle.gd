extends UnitState

func on_enter() -> void:
	unit.label.text = "Idle"
	unit.animation.play("idle")
	await tree_entered

func update(delta: float) -> void:
	if unit.current_front != Game.tileMapLayer.local_to_map(unit.position):
		change_state.emit(MOVING)
