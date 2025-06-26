extends Node

func _ready():
	Lobby.player_loaded.rpc_id(1)

func start_game():
	play_background_music.rpc()

@rpc("call_local", "any_peer", "reliable")
func play_background_music():
	$AudioStreamPlayer.play()
