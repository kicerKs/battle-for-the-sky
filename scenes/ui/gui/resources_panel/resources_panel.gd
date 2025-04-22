extends PanelContainer

func _ready():
	Game.connect("resources_changed", reload_resources)
	reload_resources()

func reload_resources():
	%WoodAmountLabel.text = str(Game.get_player_resource(Game.Resources.WOOD))
	%FoodAmountLabel.text = str(Game.get_player_resource(Game.Resources.FOOD))
	%GoldAmountLabel.text = str(Game.get_player_resource(Game.Resources.GOLD))
	%IronAmountLabel.text = str(Game.get_player_resource(Game.Resources.IRON))
	%StoneAmountLabel.text = str(Game.get_player_resource(Game.Resources.STONE))
