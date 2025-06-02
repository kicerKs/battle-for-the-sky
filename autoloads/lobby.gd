extends Node

enum Factions{
	MONSTERS,
	PLAYER_RED,
	PLAYER_BLUE,
}
const FACTION_COLORS = {
	Factions.MONSTERS: Color.WHITE,
	Factions.PLAYER_RED: Color.RED,
	Factions.PLAYER_BLUE: Color.BLUE,
}

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

signal connection_failed

const DEFAULT_SERVER_PORT = 3907
const DEFAULT_SERVER_IP = "127.0.0.1"
const MAX_CONNECTIONS = 2

var players_loaded = 0

var players = {}
var player_info = {
	"name": "Oskar",
	"color": Factions.PLAYER_BLUE
}

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(DEFAULT_SERVER_PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	player_info["color"] = Factions.PLAYER_RED
	
	players[1] = player_info
	player_connected.emit(1, player_info)
	print("game created")

func join_game(address = "", port = -1):
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	if port < 0:
		port = DEFAULT_SERVER_PORT
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)
	print(error)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	print("game joined")

@rpc("call_local", "reliable")
func load_game(path):
	get_tree().change_scene_to_file(path)

@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded+=1
		if players_loaded == players.size():
			$/root/Main.start_game()
			players_loaded = 0

func get_free_factions():
	var table = []
	for key in Factions:
		table.append(key)
	table.erase(Factions.MONSTERS)
	for key in players.keys():
		table.erase(players[key]["color"])
	return table

func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	player_info["color"] = Factions.PLAYER_BLUE
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)
	get_tree().change_scene_to_file("res://scenes/ui/lobby_menu/lobby_menu.tscn");

func _on_connected_fail():
	multiplayer.multiplayer_peer = null
	print("connection failed")
	connection_failed.emit()

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
