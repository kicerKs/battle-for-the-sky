extends Node

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1"
const MAX_CONNECTIONS = 2

var players_loaded = 0

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.connected_to_server.connect(_on_connected_ok)

func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	
	Game.players[1] = Game.player_info
	player_connected.emit(1, Game.player_info)
	print("game created")

func join_game(address = ""):
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
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
		if players_loaded == Game.players.size():
			$/root/Main.start_game()
			players_loaded = 0

func _on_player_connected(id):
	_register_player.rpc_id(id, Game.player_info)

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	Game.players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	Game.players[peer_id] = Game.player_info
	player_connected.emit(peer_id, Game.player_info)
