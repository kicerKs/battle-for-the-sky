extends MonsterState

var test_timer: float = 0.2
var wandering_timer: float = 1
var wandering_range = 650
var wandering_chance = 0.65

func on_enter() -> void:
	monster.label.text = "Idle"
	monster.animation.play("idle")
	test_timer = 0.2
	wandering_timer = 2
	print("Enter idle " + str(multiplayer.get_unique_id()))

func update(delta: float) -> void:
	# Detect enemies
	test_timer -= delta
	if test_timer <= 0:
		test_timer = 1.0
		var arr = %DetectionRange.get_overlapping_bodies()
		for body in arr:
			if body is CharacterBody2D and body != owner and body.side != owner.side and Game.tileMapLayer.local_to_map(body.position) == Game.tileMapLayer.local_to_map(owner.position):
				change_state.emit(ENGAGE)
	
	# Wandering
	wandering_timer -= delta
	if wandering_timer <= 0:
		wandering_timer = 2
		var move = Vector2(randf_range(-wandering_range, wandering_range), randf_range(-wandering_range, wandering_range))
		if randf() <= wandering_chance:
			if Game.tileMapLayer.local_to_map(owner.position) == Game.tileMapLayer.local_to_map(owner.position + move):
				var polygon = Game.tileMapLayer.tiles[Game.tileMapLayer.local_to_map(owner.position)].get_island_polygon()
				if Geometry2D.is_point_in_polygon(owner.position + move, polygon):
					monster.movement_component.start_moving(owner.position + move)
					change_state.emit(WANDERING)
