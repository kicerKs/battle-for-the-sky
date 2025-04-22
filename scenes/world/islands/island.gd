extends Sprite2D
class_name Island

@export var island_data: IslandData
var ownership: Lobby.Factions

func _ready():
	pass

#func init(data: IslandData = IslandData.new(), owner: IslandDevelopmentData.IslandOwner = IslandDevelopmentData.IslandOwner.MONSTERS):
#	island_development_data = IslandDevelopmentData.new()
#	island_development_data.ownership = owner
#	update_sprites()

func get_dict():
	return {
		"ownership" = self.ownership
	}

func set_dict(dict):
	self.ownership = dict["ownership"]
	update_sprites()

func update_sprites():
	match ownership:
		Lobby.Factions.MONSTERS:
			$Flag.texture = load("res://assets/buildings/flag_neutral.png")
		Lobby.Factions.PLAYER_RED:
			$Flag.texture = load("res://assets/buildings/flag_red.png")
		Lobby.Factions.PLAYER_BLUE:
			$Flag.texture = load("res://assets/buildings/flag_blue.png")

func add_building(building):
	building.placement_mode = false
	building.position -= self.position
	$BuildingsArea/Buildings.add_child(building)
