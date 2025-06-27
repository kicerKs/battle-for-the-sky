extends Node

var music_volume = 1:
	set(value):
		music_volume = value
		SignalBus.music_volume_changed.emit()
		Lobby.save_config()
var sound_volume = 1:
	set(value):
		sound_volume = value
		SignalBus.sound_volume_changed.emit()
		Lobby.save_config()
