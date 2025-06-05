extends UnitState

var target = null

func on_enter() -> void:
	unit.label.text = "Engage"
	target = choose_closest_target()
	if target != null:
		unit.movement_component.start_moving(target.position)
	else:
		change_state.emit(MOVING)

func physics_update(delta: float) -> void:
	unit.movement_component.update_movement(delta)
	unit.move_and_slide()

func update(delta: float) -> void:
	var array = %AttackRange.get_overlapping_bodies()
	if target in array:
		owner.attack_component.target = target
		change_state.emit(ATTACKING)

func choose_closest_target():
	var array: Array = %DetectionRange.get_overlapping_bodies()
	for el in array:
		if el is not CharacterBody2D or el == owner or el.side == owner:
			array.erase(el)
	print(array)
	if !array.is_empty():
		var closest_target = array[0]
		var closest_distance = abs(closest_target.position - owner.position)
		for target in array:
			var distance = abs(target.position - owner.position)
			if distance < closest_distance:
				closest_target = target
				closest_distance = distance
		print(closest_target.position)
		return closest_target
	return null
