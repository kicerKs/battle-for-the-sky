extends UnitState

@onready var attack_speed = owner.stats.actionSpeed
var timer = attack_speed

func on_enter() -> void:
	unit.label.text = "Attacking"
	unit.animation.play("attack")
	timer = attack_speed

func physics_update(delta: float) -> void:
	unit.movement_component.update_movement(delta)
	unit.move_and_slide()
	for i in unit.get_slide_collision_count():
		var collision = unit.get_slide_collision(i)
		unit.movement_component.add_collision(collision.get_remainder())

func update(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		timer = attack_speed
		if owner.attack_component.target != null:
			owner.attack_component.damage()
	var array = %AttackRange.get_overlapping_bodies()
	if owner.attack_component.target == null or owner.attack_component.target not in array:
		change_state.emit(ENGAGE)
	
	
	# if no enemy nearby
	#	if state_machine.previous_state_name == CONQUERING:
	#		change_state.emit(CONQUERING)
	#	if state_machine.previous_state_name == MOVING:
	#		change_state.emit(MOVING)
