extends UnitState

var target = null

func on_enter() -> void:
	unit.label.text = "Engage"
	unit.animation.play("walk")
	target = choose_closest_target()
	if target != null:
		unit.movement_component.start_moving(target.position)
	else:
		change_state.emit(MOVING)
		return

func physics_update(delta: float) -> void:
	unit.movement_component.update_movement(delta)
	unit.move_and_slide()
	for i in unit.get_slide_collision_count():
		var collision = unit.get_slide_collision(i)
		unit.movement_component.add_collision(collision.get_remainder())

func update(delta: float) -> void:
	target = choose_closest_target()
	if target == null:
		change_state.emit(MOVING)
		return
	unit.movement_component.start_moving(target.position)
	var array: Array = %AttackRange.get_overlapping_bodies()
	if target in array:
		if owner.has_node("Components/AttackComponent") and target.side != owner.side:
			owner.attack_component.target = target
		if owner.has_node("Components/HealComponent") and target.side == owner.side:
			owner.heal_component.target = target
		owner.movement_component.end_moving()
		change_state.emit(ATTACKING)

func choose_closest_target():
	var array: Array = %DetectionRange.get_overlapping_bodies()
	var new_array: Array = []
	for el: CharacterBody2D in array:
		if el is not TestCharacter and el is not TestMonster:
			continue
		elif el == owner:
			continue
		elif el.side == owner.side and owner.has_node("Components/HealComponent") and !el.health_component.is_max_hp():
			new_array.append(el)
		elif el.side != owner.side and owner.has_node("Components/AttackComponent"):
			new_array.append(el)
	if !new_array.is_empty():
		var closest_target = new_array[0]
		var closest_distance = abs(closest_target.position - owner.position)
		for target in new_array:
			var distance = abs(target.position - owner.position)
			if distance < closest_distance:
				closest_target = target
				closest_distance = distance
		return closest_target
	return null
