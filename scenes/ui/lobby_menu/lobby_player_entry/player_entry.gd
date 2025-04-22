extends PanelContainer

func add_player(peer_id, player_info):
	%PlayerName.text = player_info["name"]
	%Color.color = Lobby.FACTION_COLORS[player_info["color"]]
	if peer_id == 1:
		%Peer.text = "Host"
	else:
		%Peer.text = "Client"
	%Status.text = "Status: Connected"
