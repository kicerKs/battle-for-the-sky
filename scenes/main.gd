extends Node

func _ready():
	Lobby.player_loaded.rpc_id(1)
	SignalBus.player_won.connect(play_victory_music)
	SignalBus.player_eliminated.connect(play_elimination_music)

func start_game():
	play_background_music.rpc()

@rpc("call_local", "any_peer", "reliable")
func play_background_music():
	$AudioStreamPlayer.play()

@rpc("call_local", "any_peer", "reliable")
func play_victory_music(id):
	if id == multiplayer.get_unique_id():
		$WinMusic.play()
		$AudioStreamPlayer.stop()

@rpc("call_local", "any_peer", "reliable")
func play_elimination_music(id):
	if id == multiplayer.get_unique_id():
		$DefeatMusic.play()
		$AudioStreamPlayer.stop()
