extends Node
class_name UpgradeComponent

@export var upgrade_cost: Dictionary[Game.Resources, int] = { 
	Game.Resources.WOOD: 0,
	Game.Resources.FOOD: 0,
	Game.Resources.STONE: 0,
	Game.Resources.IRON: 0,
	Game.Resources.GOLD: 0
}
@export var upgraded_building: BuildingStats
@export var generator_stats: GeneratorStats
@export var trainer_stats: TrainerStats

func upgrade():
	if owner.has_node("GeneratorComponent"):
		owner.get_node("GeneratorComponent").stats = generator_stats
		owner.get_node("GeneratorComponent").reset_timer()
	if owner.has_node("TrainComponent"):
		owner.get_node("TrainComponent").stats = trainer_stats
	owner.stats = upgraded_building
	SignalBus.building_clicked.emit(owner)
	queue_free()

func _on_upgrade_button_pressed() -> void:
	#Check if player has enough resources
	#Then subtract these resources
	#And now upgrade the building
	upgrade()
	#And disable the button completely
	%UpgradeButton.disabled = true
