extends MonsterState

func on_enter() -> void:
	monster.label.text = "Wandering"
	monster.animation.play("walk")

func physics_update(delta: float) -> void:
	monster.movement_component.update_movement(delta)
	monster.move_and_slide()

func update(delta: float) -> void:
	var arr = %DetectionRange.get_overlapping_bodies()
	for body in arr:
		if body is CharacterBody2D and body != owner and body.side != owner.side and Game.tileMapLayer.local_to_map(body.position) == Game.tileMapLayer.local_to_map(owner.position):
			change_state.emit(ENGAGE)
			return
	if monster.nav_agent.is_navigation_finished():
		change_state.emit(IDLE)
