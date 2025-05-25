extends UnitState

func on_enter():
	unit.label.text = "Attacking"
	owner.animation.play("attack")
	
