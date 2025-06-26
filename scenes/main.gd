extends Node

func _ready():
	Lobby.player_loaded.rpc_id(1)

func start_game():
	$AudioStreamPlayer.play()
