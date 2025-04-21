extends Node

# Here everything that needs to be accessed from several places, but is connected with current playthrough, like resources etc.

var players = {}
var player_info = {
	"name": "Player",
	"color": IslandDevelopmentData.IslandOwner.PLAYER_RED
}
