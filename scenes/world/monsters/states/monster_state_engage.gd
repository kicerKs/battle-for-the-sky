extends MonsterState
var target = null

func on_enter() -> void:
	monster.label.text = "Engage"
	monster.animation.play("walk")
	target = choose_closest_target()
	if target != null:
		monster.movement_component.start_moving(target.position)
	else:
		change_state.emit(IDLE)
		return

func physics_update(delta: float) -> void:
	monster.movement_component.update_movement(delta)
	monster.move_and_slide()

func update(delta: float) -> void:
	if target == null:
		change_state.emit(IDLE)
		return
	monster.movement_component.start_moving(target.position)
	var array = %AttackRange.get_overlapping_bodies()
	if target in array:
		owner.attack_component.target = target
		print("I start attacking " + str(target))
		change_state.emit(ATTACKING)

func choose_closest_target():
	var array: Array = %DetectionRange.get_overlapping_bodies()
	var new_array: Array = []
	for el: CharacterBody2D in array:
		print(el)
		if el is not TestCharacter:
			continue
		elif el == owner:
			continue
		elif el.side == owner.side:
			continue
		elif Game.tileMapLayer.local_to_map(el.position) != Game.tileMapLayer.local_to_map(owner.position):
			continue
		else:
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
