extends UnitState

@onready var attack_speed = owner.stats.actionSpeed
var timer = attack_speed

func on_enter() -> void:
	unit.label.text = "Attacking"
	unit.animation.play("attack")
	timer = attack_speed

func physics_update(delta: float) -> void:
	var original_velocity = unit.movement_component.get_velocity()
	unit.move_and_slide()
	
	# Handle collisions
	if unit.get_slide_collision_count() > 0:
		var total_repulsion = Vector2.ZERO
		var collision_count = 0
		
		# Collect collision data
		for i in unit.get_slide_collision_count():
			var collision = unit.get_slide_collision(i)
			var collider = collision.get_collider()
			
			# Only react to other units (not walls/obstacles)
			if collider.is_in_group("units"):
				var push_vector = collision.get_normal() * collision.get_remainder().length()
				total_repulsion += push_vector
				collision_count += 1
		
		# Calculate average repulsion if we had collisions
		if collision_count > 0:
			var average_repulsion = total_repulsion / collision_count
			var modified_velocity = original_velocity + (average_repulsion * 0.5)  # Dampen the effect
			
			# Apply the modified velocity
			unit.movement_component.set_velocity(modified_velocity)
	
	# Update movement with potential new velocity
	unit.movement_component.update_movement(delta)

func update(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		timer = attack_speed
		if owner.has_node("Components/HealComponent"):
			owner.heal_component.heal()
		elif owner.attack_component.target != null:
			owner.attack_component.damage()
	var array = %AttackRange.get_overlapping_bodies()
	if owner.has_node("Components/AttackComponent"):
		if owner.attack_component.target == null or owner.attack_component.target not in array:
			change_state.emit(ENGAGE)
	elif owner.has_node("Components/HealComponent"):
		if owner.heal_component.target == null or owner.heal_component.target not in array or owner.heal_component.target.health_component.is_max_hp():
			#print(owner.heal_component.target, owner.heal_component.target.health_component.is_max_hp())
			change_state.emit(ENGAGE)
	if owner.attack_component.target.global_position.x < owner.global_position.x:
		owner.animation.flip_h = true
	else:
		owner.animation.flip_h = false
	
	# if no enemy nearby
	#	if state_machine.previous_state_name == CONQUERING:
	#		change_state.emit(CONQUERING)
	#	if state_machine.previous_state_name == MOVING:
	#		change_state.emit(MOVING)
