extends UnitState

func on_enter() -> void:
	unit.label.text = "Attacking"
	unit.animation.play("attack")
