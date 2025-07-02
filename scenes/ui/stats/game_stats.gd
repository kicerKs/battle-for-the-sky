extends Control

func _ready():
	var config = ConfigFile.new()
	var err = config.load("user://stats/"+Global.game_name)
	print(err)
	print(Global.game_name)
	if err != OK:
		return
	
	%BuildingsBuilt.text = str(config.get_value("Islands", "buildings_built"))
	%IslandsConquered.text = str(config.get_value("Islands", "islands_conquered"))
	%IslandsLost.text = str(config.get_value("Islands", "islands_lost"))
	%MonstersKilled.text = str(config.get_value("Units", "monsters_killed"))
	%UnitsKilled.text = str(config.get_value("Units", "units_killed"))
	%UnitsLost.text = str(config.get_value("Units", "units_lost"))
	%WoodGen.text = str(config.get_value("ResourcesGenerated", "wood"))
	%FoodGen.text = str(config.get_value("ResourcesGenerated", "food"))
	%IronGen.text = str(config.get_value("ResourcesGenerated", "iron"))
	%GoldGen.text = str(config.get_value("ResourcesGenerated", "gold"))
	%StoneGen.text = str(config.get_value("ResourcesGenerated", "stone"))
	%WoodSpt.text = str(config.get_value("ResourcesSpent", "wood"))
	%FoodSpt.text = str(config.get_value("ResourcesSpent", "food"))
	%GoldSpt.text = str(config.get_value("ResourcesSpent", "gold"))
	%IronSpt.text = str(config.get_value("ResourcesSpent", "iron"))
	%StoneSpt.text = str(config.get_value("ResourcesSpent", "stone"))
	%Peasant.text = str(config.get_value("Units", "Peasant"))
	%Soldier.text = str(config.get_value("Units", "Soldier"))
	%Archer.text = str(config.get_value("Units", "Archer"))
	%Crossbowman.text = str(config.get_value("Units", "Crossbowman"))
	%Druid.text = str(config.get_value("Units", "Druid"))
	%Mage.text = str(config.get_value("Units", "Mage"))
	%Knight.text = str(config.get_value("Units", "Knight"))
	%Cavalry.text = str(config.get_value("Units", "Cavalry"))
	%Catapult.text = str(config.get_value("Units", "Catapult"))
	%Cannon.text = str(config.get_value("Units", "Cannon"))
	%Priest.text = str(config.get_value("Units", "Priest"))
	%Cleric.text = str(config.get_value("Units", "Cleric"))
	


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/stats/stats.tscn")
