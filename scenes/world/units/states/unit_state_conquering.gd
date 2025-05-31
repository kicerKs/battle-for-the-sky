extends UnitState

func on_enter() -> void:
	unit.label.text = "Conquering"
	unit.animation.play("idle")
	var island = Game.tileMapLayer.tiles[Game.tileMapLayer.local_to_map(unit.position)]
	island.start_conquering(unit.side)
	island.connect("island_conquered", _on_island_conquered)

func _on_island_conquered():
	change_state.emit(IDLE)

# If enemy spotted, change to attacking state
