extends MonsterState

var test_timer: float = 0.2

func on_enter() -> void:
	monster.label.text = "Idle"
	monster.animation.play("idle")

func update(delta: float) -> void:
	test_timer -= delta
	if test_timer <= 0:
		test_timer = 1.0
		var arr = %DetectionRange.get_overlapping_bodies()
		for body in arr:
			if body is CharacterBody2D and body != owner and body.side != owner.side and Game.tileMapLayer.local_to_map(body.position) == Game.tileMapLayer.local_to_map(owner.position):
				change_state.emit(ENGAGE)
