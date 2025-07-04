extends Control

var player_entry_scene = load("res://scenes/ui/lobby_menu/lobby_player_entry/player_entry.tscn")

var player_entries = {}

func _ready():
	# Connections for players joining/leaving
	Lobby.connect("player_connected", _add_new_player)
	Lobby.connect("player_disconnected", _remove_player)
	
	# First set-up
	if !multiplayer.is_server():
		%StartButton.disabled = true
	for key in Lobby.players.keys():
		_add_new_player(key, Lobby.players[key])
	var host_name = Lobby.players[1]["name"]
	$PanelContainer/VBoxContainer/Label.text = host_name + "'s Game"

func _add_new_player(peer_id, player_info):
	var scene = player_entry_scene.instantiate()
	scene.add_player(peer_id, player_info)
	%PlayerEntries.add_child(scene)
	player_entries[peer_id] = scene

func _remove_player(peer_id):
	%PlayerEntries.remove_child(player_entries[peer_id])
	player_entries[peer_id] = null

func _on_start_button_pressed() -> void:
	Lobby.load_game.rpc("res://scenes/main.tscn")

func _on_button_pressed() -> void:
	Game.map_size = Game.MAP_SIZE.SMALL

func _on_button_2_pressed() -> void:
	Game.map_size = Game.MAP_SIZE.MEDIUM

func _on_button_3_pressed() -> void:
	Game.map_size = Game.MAP_SIZE.LARGE
