extends TileMapLayer

var tiles = { }

func _ready():
	connect("child_entered_tree", register_child)
	connect("child_exiting_tree", unregister_child)

func register_child(node: Node):
	tiles[local_to_map(node.position)] = node
	# Tutaj info z wygenerowanej mapy, wrzucimy to potem może w jeden resource, albo i nie, idk
	node.init(IslandData.new(), IslandDevelopmentData.IslandOwner.PLAYER_RED)

func unregister_child(node: Node):
	tiles.erase(local_to_map(node.position))
