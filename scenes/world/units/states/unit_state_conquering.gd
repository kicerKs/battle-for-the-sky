extends UnitState

@export var conquering_time: float = 10

var timer: float = 0
var timer_started: bool = false

func on_enter() -> void:
	unit.label.text = "Conquering"
	unit.animation.play("idle")
	timer = conquering_time
	timer_started = true

func update(delta: float) -> void:
	if timer_started:
		timer -= delta
		print(timer)
		if timer <= 0:
			
			change_state.emit(IDLE)
