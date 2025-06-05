extends UnitState

@onready var attack_speed = owner.stats.actionSpeed
var timer = attack_speed

func on_enter() -> void:
	unit.label.text = "Attacking"
	unit.animation.play("attack")
	timer = 0

func update(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		timer = attack_speed
		if owner.attack_component.target != null:
			owner.attack_component.damage()
		else:
			change_state.emit(ENGAGE)
	elif owner.attack_component.target == null:
		change_state.emit(ENGAGE)
	
	
	# if no enemy nearby
	#	if state_machine.previous_state_name == CONQUERING:
	#		change_state.emit(CONQUERING)
	#	if state_machine.previous_state_name == MOVING:
	#		change_state.emit(MOVING)
