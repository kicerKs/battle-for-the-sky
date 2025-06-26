extends Node

enum Factions{
	MONSTERS,
	PLAYER_RED,
	PLAYER_BLUE,
	PLAYER_PURPLE,
	PLAYER_GREEN
}
const FACTION_COLORS = {
	Factions.MONSTERS: Color.WHITE,
	Factions.PLAYER_RED: Color.RED,
	Factions.PLAYER_BLUE: Color.BLUE,
	Factions.PLAYER_PURPLE: Color.PURPLE,
	Factions.PLAYER_GREEN: Color.GREEN
}

var next_player_color = 2
var colors_changed = [1]

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

signal connection_failed

const DEFAULT_SERVER_PORT = 3907
const DEFAULT_SERVER_IP = "127.0.0.1"
const MAX_CONNECTIONS = 4

var players_loaded = 0

var players = {}
var player_info = {
	"name": "Oskar",
	"color": Factions.PLAYER_RED,
	"in_game": true
}
var last_used_ip
var last_used_port

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	load_config()
	if last_used_ip == null:
		last_used_ip = DEFAULT_SERVER_IP
	if last_used_port == null:
		last_used_port = DEFAULT_SERVER_PORT

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
	last_used_ip = address
	last_used_port = port
	save_config()
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)
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
	print("player connected ", multiplayer.get_unique_id())
	_register_player.rpc_id(id, player_info)

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	if multiplayer.is_server():
		if multiplayer.get_remote_sender_id() not in colors_changed:
			new_player_info["color"] = next_player_color
			next_player_color += 1
			colors_changed.append(multiplayer.get_remote_sender_id())
			update_color.rpc(multiplayer.get_remote_sender_id(), new_player_info)
	var new_player_id = multiplayer.get_remote_sender_id()
	if !players.has(new_player_id):
		players[new_player_id] = new_player_info
		player_connected.emit(new_player_id, new_player_info)
	else:
		player_connected.emit(new_player_id, players[new_player_id])
	if new_player_id == 1 and !multiplayer.is_server():
		get_tree().change_scene_to_file("res://scenes/ui/lobby_menu/lobby_menu.tscn")

@rpc("any_peer", "reliable", "call_local")
func update_color(id, play_inf):
	if id == multiplayer.get_unique_id():
		player_info = play_inf
	players[id] = play_inf
	SignalBus.player_info_changed.emit(id)

func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	#player_info["color"] = Factions.PLAYER_BLUE
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)

func _on_connected_fail():
	multiplayer.multiplayer_peer = null
	print("connection failed")
	connection_failed.emit()

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()

func load_config():
	var config = ConfigFile.new()
	
	var err = config.load("user://config.cfg")
	
	if err != OK:
		return
	
	player_info["name"] = config.get_value("Multiplayer", "player_name")
	last_used_ip = config.get_value("Multiplayer", "last_ip")
	last_used_port = config.get_value("Multiplayer", "last_port")

func save_config():
	var config = ConfigFile.new()
	
	config.set_value("Multiplayer", "player_name", player_info["name"])
	if last_used_ip != null:
		config.set_value("Multiplayer", "last_ip", last_used_ip)
	else:
		config.set_value("Multiplayer", "last_ip", DEFAULT_SERVER_IP)
	if last_used_port != null:
		config.set_value("Multiplayer", "last_port", last_used_port)
	else:
		config.set_value("Multiplayer", "last_port", DEFAULT_SERVER_PORT)
	
	config.save("user://config.cfg")
