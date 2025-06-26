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
		owner.get_node("GeneratorComponent").reload_resource_indicator()
	if owner.has_node("TrainComponent"):
		owner.get_node("TrainComponent").stats = trainer_stats
	owner.stats = upgraded_building
	SignalBus.building_clicked.emit(owner)
	SignalBus.hide_resource_cost.emit()
	start_animation.rpc()
	queue_free()

@rpc("any_peer", "call_local", "reliable")
func start_animation():
	$"../AnimatedSprite2D".visible = true
	$"../AnimatedSprite2D".play("default")

func _on_upgrade_button_pressed() -> void:
	for res in upgrade_cost.keys():
		if Game.get_player_resource(res) < upgrade_cost[res]:
			return
	for res in upgrade_cost.keys():
		Game.change_player_resource(res, -upgrade_cost[res])
	#Check if player has enough resources
	#Then subtract these resources
	#And now upgrade the building
	upgrade()
	#And disable the button completely
	%UpgradeButton.disabled = true

func _on_upgrade_button_mouse_entered() -> void:
	SignalBus.show_resource_cost.emit(upgrade_cost)

func _on_upgrade_button_mouse_exited() -> void:
	SignalBus.hide_resource_cost.emit()
