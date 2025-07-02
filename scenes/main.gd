extends Node

func _ready():
	Lobby.player_loaded.rpc_id(1)
	SignalBus.player_won.connect(play_victory_music)
	SignalBus.player_eliminated.connect(play_elimination_music)
	SignalBus.island_conquered.connect(play_island_change_sounds)
	SignalBus.music_volume_changed.connect(set_background_music_volume)
	SignalBus.sound_volume_changed.connect(set_sound_volume)
	set_sound_volume()
	set_background_music_volume()
	Lobby.load_config()

func start_game():
	play_background_music.rpc()
	Global.game_name = str(Time.get_datetime_string_from_system())
	Global.game_name = Global.game_name.replace(":","_")
	Global.game_name = Global.game_name.replace("-","_")
	$GUI/Timer.start()

@rpc("call_local", "any_peer", "reliable")
func play_background_music():
	$AudioStreamPlayer.play()

func set_background_music_volume():
	$AudioStreamPlayer.volume_linear = AudioManager.music_volume

func set_sound_volume():
	$WinMusic.volume_linear = AudioManager.sound_volume
	$DefeatMusic.volume_linear = AudioManager.sound_volume
	$IslandConquered.volume_linear = AudioManager.sound_volume
	$IslandLost.volume_linear = AudioManager.sound_volume

@rpc("call_local", "any_peer", "reliable")
func play_victory_music(id):
	if id == multiplayer.get_unique_id():
		$WinMusic.play()
		$AudioStreamPlayer.stop()
		$GUI/Timer.stop()

@rpc("call_local", "any_peer", "reliable")
func play_elimination_music(id):
	if id == multiplayer.get_unique_id():
		$DefeatMusic.play()
		$AudioStreamPlayer.stop()
		$GUI/Timer.stop()

func play_island_change_sounds(before, after):
	pics.rpc(before, after)
	
@rpc("call_local", "any_peer", "reliable")
func pics(before, after):
	if Lobby.player_info["color"] == before:
		$IslandLost.play()
	if Lobby.player_info["color"] == after:
		$IslandConquered.play()
