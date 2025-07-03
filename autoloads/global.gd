extends Node

# Game statistics

var game_name = ""

var game_time = 0
var units_killed = 0
var monsters_killed = 0
var units_lost = 0
var islands_conquered = 0
var islands_lost = 0
var buildings_built = 0
var units_trained = {
	"Peasant": 0,
	"Soldier": 0,
	"Archer": 0,
	"Crossbowman": 0,
	"Druid": 0,
	"Mage": 0,
	"Knight": 0,
	"Cavalry": 0,
	"Catapult": 0,
	"Cannon": 0,
	"Priest": 0,
	"Cleric": 0
}
var resources_generated = {
	Game.Resources.WOOD: 0,
	Game.Resources.FOOD: 0,
	Game.Resources.GOLD: 0,
	Game.Resources.IRON: 0,
	Game.Resources.STONE: 0
}
var resources_spent = {
	Game.Resources.WOOD: 0,
	Game.Resources.FOOD: 0,
	Game.Resources.GOLD: 0,
	Game.Resources.IRON: 0,
	Game.Resources.STONE: 0
}

func _ready():
	SignalBus.connect("resource_generated", add_resource_generated)
	SignalBus.connect("resource_spent", add_resource_spent)
	SignalBus.connect("island_conquered", service_island_conquered)
	SignalBus.connect("building_built", service_building_built)
	SignalBus.connect("unit_trained", service_unit_trained)
	SignalBus.connect("unit_died", service_unit_died)
	SignalBus.connect("unit_killed", service_unit_killed)
	SignalBus.connect("monster_killed", service_monster_killed)

func service_island_conquered(before, after):
	if multiplayer.is_server():
		add_island_conquered.rpc_id(Lobby.get_player_id_by_color(after))
		if before != Lobby.Factions.MONSTERS:
			add_island_lost.rpc_id(Lobby.get_player_id_by_color(before))

func service_building_built(side):
	if multiplayer.is_server():
		add_building_built.rpc_id(Lobby.get_player_id_by_color(side))

func service_unit_trained(name, side):
	if multiplayer.is_server():
		add_unit_trained.rpc_id(Lobby.get_player_id_by_color(side), name)

func service_unit_died(side):
	if multiplayer.is_server():
		add_unit_lost.rpc_id(Lobby.get_player_id_by_color(side))

func service_unit_killed(side):
	if multiplayer.is_server():
		add_unit_killed.rpc_id(Lobby.get_player_id_by_color(side))

func service_monster_killed(side):
	if multiplayer.is_server():
		add_monster_killed.rpc_id(Lobby.get_player_id_by_color(side))

@rpc("any_peer", "call_local", "reliable")
func add_island_conquered():
	islands_conquered += 1
	save_stats()

@rpc("any_peer", "call_local", "reliable")
func add_island_lost():
	islands_lost += 1
	save_stats()

@rpc("any_peer", "call_local", "reliable")
func add_building_built():
	buildings_built += 1
	save_stats()

@rpc("any_peer", "call_local", "reliable")
func add_unit_trained(name):
	units_trained[name] += 1
	save_stats()

@rpc("any_peer", "call_local", "reliable")
func add_unit_killed():
	units_killed += 1
	save_stats()

@rpc("any_peer", "call_local", "reliable")
func add_monster_killed():
	monsters_killed += 1
	save_stats()
	
@rpc("any_peer", "call_local", "reliable")
func add_unit_lost():
	units_lost += 1
	save_stats()

func set_game_time(time):
	game_time = time
	save_stats()

func add_resource_generated(resource, number):
	resources_generated[resource] += number
	save_stats()

func add_resource_spent(resource, number):
	resources_spent[resource] += number
	save_stats()

func save_stats():
	var save = ConfigFile.new()
	save.set_value("Units", "units_killed", units_killed)
	save.set_value("Units", "monsters_killed", monsters_killed)
	save.set_value("Units", "units_lost", units_lost)
	save.set_value("Units", "Peasant", units_trained["Peasant"])
	save.set_value("Units", "Soldier", units_trained["Soldier"])
	save.set_value("Units", "Archer", units_trained["Archer"])
	save.set_value("Units", "Crossbowman", units_trained["Crossbowman"])
	save.set_value("Units", "Druid", units_trained["Druid"])
	save.set_value("Units", "Mage", units_trained["Mage"])
	save.set_value("Units", "Knight", units_trained["Knight"])
	save.set_value("Units", "Cavalry", units_trained["Cavalry"])
	save.set_value("Units", "Catapult", units_trained["Catapult"])
	save.set_value("Units", "Cannon", units_trained["Cannon"])
	save.set_value("Units", "Priest", units_trained["Priest"])
	save.set_value("Units", "Cleric", units_trained["Cleric"])
	save.set_value("Islands", "islands_conquered", islands_conquered)
	save.set_value("Islands", "islands_lost", islands_lost)
	save.set_value("Islands", "buildings_built", buildings_built)
	save.set_value("ResourcesGenerated", "wood", resources_generated[Game.Resources.WOOD])
	save.set_value("ResourcesGenerated", "food", resources_generated[Game.Resources.FOOD])
	save.set_value("ResourcesGenerated", "gold", resources_generated[Game.Resources.GOLD])
	save.set_value("ResourcesGenerated", "iron", resources_generated[Game.Resources.IRON])
	save.set_value("ResourcesGenerated", "stone", resources_generated[Game.Resources.STONE])
	save.set_value("ResourcesSpent", "wood", resources_spent[Game.Resources.WOOD])
	save.set_value("ResourcesSpent", "food", resources_spent[Game.Resources.FOOD])
	save.set_value("ResourcesSpent", "gold", resources_spent[Game.Resources.GOLD])
	save.set_value("ResourcesSpent", "iron", resources_spent[Game.Resources.IRON])
	save.set_value("ResourcesSpent", "stone", resources_spent[Game.Resources.STONE])
	save.set_value("Game", "time", game_time)
	if !DirAccess.dir_exists_absolute("user://stats"):
		DirAccess.make_dir_absolute("user://stats")
	save.save("user://stats/game_"+game_name+".save")
