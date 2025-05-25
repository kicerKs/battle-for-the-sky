extends UnitState

func on_enter():
	unit.label.text = "Conquering"
	owner.animation.play("idle")
