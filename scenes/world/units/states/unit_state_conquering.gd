extends UnitState

func on_enter() -> void:
	unit.label.text = "Conquering"
	unit.animation.play("idle")
	if multiplayer.is_server():
		var island = Game.tileMapLayer.tiles[Game.tileMapLayer.local_to_map(unit.position)]
		if !island.is_conquering():
			island.start_conquering(unit.side)
		island.connect("island_conquered", _on_island_conquered)
		island.connect("conquering_interrupted", _on_conquering_interrupted)

func _on_island_conquered():
	conquered.rpc()

func _on_conquering_interrupted():
	change_state.emit(MOVING)

# If enemy spotted, change to attacking state

@rpc("any_peer", "call_local", "reliable")
func conquered():
	change_state.emit(IDLE)
