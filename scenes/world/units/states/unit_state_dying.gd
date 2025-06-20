extends UnitState

func on_enter() -> void:
	unit.label.text = "Dying"
	unit.animation.play("death")

func update(delta: float) -> void:
	if !unit.animation.is_playing():
		owner.die.rpc()
