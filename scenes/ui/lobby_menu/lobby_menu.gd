extends Control

var player_entry_scene = load("res://scenes/ui/lobby_menu/lobby_player_entry/player_entry.tscn")

func _ready():
	if !multiplayer.is_server():
		%StartButton.disabled = true
	Lobby.connect("player_connected", _add_new_player)
	for key in Game.players.keys():
		_add_new_player(key, Game.players[key])

func _add_new_player(peer_id, player_info):
	var scene = player_entry_scene.instantiate()
	scene.add_player(peer_id, player_info)
	%PlayerEntries.add_child(scene)

func _on_start_button_pressed() -> void:
	Lobby.load_game.rpc("res://scenes/main.tscn")
