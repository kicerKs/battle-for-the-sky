extends PanelContainer

func setup(building: Building):
	%"Upgrade Container".visible = false
	%BuildingIcon.texture = building.stats.icon
	%BuildingName.text = building.stats.name
	%Description.text = building.stats.description
	if building.has_node("GeneratorComponent"):
		%"Unit Container".visible = false
		%"Resource Container".visible = true
		var stats: GeneratorStats = building.get_node("GeneratorComponent").stats
		%ResWood.visible = true
		%ResFood.visible = true
		%ResGold.visible = true
		%ResStone.visible = true
		%ResIron.visible = true
		%ResTime.visible = true
		if stats.generatingResources[Game.Resources.WOOD] == 0:
			%ResWood.visible = false
		else:
			%ResWoodCountLabel.text = str(stats.generatingResources[Game.Resources.WOOD])
		if stats.generatingResources[Game.Resources.FOOD] == 0:
			%ResFood.visible = false
		else:
			%ResFoodCountLabel.text = str(stats.generatingResources[Game.Resources.FOOD])
		if stats.generatingResources[Game.Resources.GOLD] == 0:
			%ResGold.visible = false
		else:
			%ResGoldCountLabel.text = str(stats.generatingResources[Game.Resources.GOLD])
		if stats.generatingResources[Game.Resources.STONE] == 0:
			%ResStone.visible = false
		else:
			%ResStoneCountLabel.text = str(stats.generatingResources[Game.Resources.STONE])
		if stats.generatingResources[Game.Resources.IRON] == 0:
			$%ResIron.visible = false
		else:
			%ResIronCountLabel.text = str(stats.generatingResources[Game.Resources.IRON])
		%ResTimeCountLabel.text = str(stats.generatingTime)
	if building.has_node("TrainComponent"):
		%"Unit Container".visible = true
		%"Resource Container".visible = false
		%UniWood.visible = true
		%UniFood.visible = true
		%UniGold.visible = true
		%UniStone.visible = true
		%UniIron.visible = true
		%UniTime.visible = true
		var stats: TrainerStats = building.get_node("TrainComponent").stats
		%UnitTextureRect.texture = stats.unit_icon
		if stats.training_cost[Game.Resources.WOOD] == 0:
			%UniWood.visible = false
		else:
			%UniWoodCountLabel.text = str(stats.training_cost[Game.Resources.WOOD])
		if stats.training_cost[Game.Resources.FOOD] == 0:
			%UniFood.visible = false
		else:
			%UniFoodCountLabel.text = str(stats.training_cost[Game.Resources.FOOD])
		if stats.training_cost[Game.Resources.GOLD] == 0:
			%UniGold.visible = false
		else:
			%UniGoldCountLabel.text = str(stats.training_cost[Game.Resources.GOLD])
		if stats.training_cost[Game.Resources.STONE] == 0:
			%UniStone.visible = false
		else:
			%UniStoneCountLabel.text = str(stats.training_cost[Game.Resources.STONE])
		if stats.training_cost[Game.Resources.IRON] == 0:
			%UniIron.visible = false
		else:
			%UniIronCountLabel.text = str(stats.training_cost[Game.Resources.IRON])
		%UniTimeCountLabel.text = str(stats.training_time)
	if building.has_node("UpgradeComponent") and !building.stats.is_upgraded:
		%"Upgrade Container".visible = true
		%UpWood.visible = true
		%UpFood.visible = true
		%UpGold.visible = true
		%UpStone.visible = true
		%UpIron.visible = true
		var node: UpgradeComponent = building.get_node("UpgradeComponent")
		if node.upgrade_cost[Game.Resources.WOOD] == 0:
			%UpWood.visible = false
		else:
			%UpWoodCountLabel.text = str(node.upgrade_cost[Game.Resources.WOOD])
		if node.upgrade_cost[Game.Resources.FOOD] == 0:
			%UpFood.visible = false
		else:
			%UpFoodCountLabel.text = str(node.upgrade_cost[Game.Resources.FOOD])
		if node.upgrade_cost[Game.Resources.GOLD] == 0:
			%UpGold.visible = false
		else:
			%UpGoldCountLabel.text = str(node.upgrade_cost[Game.Resources.GOLD])
		if node.upgrade_cost[Game.Resources.STONE] == 0:
			%UpStone.visible = false
		else:
			%UpStoneCountLabel.text = str(node.upgrade_cost[Game.Resources.STONE])
		if node.upgrade_cost[Game.Resources.IRON] == 0:
			%UpIron.visible = false
		else:
			%UpIronCountLabel.text = str(node.upgrade_cost[Game.Resources.IRON])
