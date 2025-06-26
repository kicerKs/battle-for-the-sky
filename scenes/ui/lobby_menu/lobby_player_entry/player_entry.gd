extends PanelContainer

var player_id

func _ready():
	SignalBus.player_info_changed.connect(refresh)

func add_player(peer_id, player_info):
	player_id = peer_id
	%PlayerName.text = player_info["name"]
	%Color.color = Lobby.FACTION_COLORS[player_info["color"]]
	if peer_id == 1:
		%Peer.text = "Host"
	else:
		%Peer.text = "Client"
	%Status.text = "Status: Connected"

func refresh(id):
	if id == player_id:
		var player_info = Lobby.players[id]
		%PlayerName.text = player_info["name"]
		%Color.color = Lobby.FACTION_COLORS[player_info["color"]]
