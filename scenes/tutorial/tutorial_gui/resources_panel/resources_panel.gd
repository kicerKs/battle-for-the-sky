extends PanelContainer

func _ready():
	Game.connect("resources_changed", reload_resources)
	SignalBus.connect("show_resource_cost", show_cost)
	SignalBus.connect("hide_resource_cost", hide_cost)
	reload_resources()

func reload_resources():
	%WoodAmountLabel.text = str(Game.get_player_resource(Game.Resources.WOOD))
	%FoodAmountLabel.text = str(Game.get_player_resource(Game.Resources.FOOD))
	%GoldAmountLabel.text = str(Game.get_player_resource(Game.Resources.GOLD))
	%IronAmountLabel.text = str(Game.get_player_resource(Game.Resources.IRON))
	%StoneAmountLabel.text = str(Game.get_player_resource(Game.Resources.STONE))

func show_cost(dict):
	%WoodChangeLabel.text = " - "+str(dict[Game.Resources.WOOD])
	%FoodChangeLabel.text = " - "+str(dict[Game.Resources.FOOD])
	%GoldChangeLabel.text = " - "+str(dict[Game.Resources.GOLD])
	%IronChangeLabel.text = " - "+str(dict[Game.Resources.IRON])
	%StoneChangeLabel.text = " - "+str(dict[Game.Resources.STONE])

func hide_cost():
	%WoodChangeLabel.text = ""
	%FoodChangeLabel.text = ""
	%GoldChangeLabel.text = ""
	%IronChangeLabel.text = ""
	%StoneChangeLabel.text = ""
