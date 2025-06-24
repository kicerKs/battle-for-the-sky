extends Node2D


func _on_timer_timeout() -> void:
	if multiplayer.is_server():
		remove.rpc()

@rpc("call_local", "any_peer", "reliable")
func remove():
	queue_free()
