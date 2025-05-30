extends UnitState

@export var conquering_time: float = 10

var timer: float = 0
var timer_started: bool = false

func on_enter() -> void:
	unit.label.text = "Conquering"
	unit.animation.play("idle")
	timer = conquering_time
	timer_started = true
	Game.tileMapLayer.start_conquering(unit.position, unit.side)

func update(delta: float) -> void:
	if get_current_island_ownership() == unit.side:
		change_state.emit(IDLE)
