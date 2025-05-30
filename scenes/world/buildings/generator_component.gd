extends Node
class_name GeneratorComponent

@export var stats: GeneratorStats

var is_active: bool = false
var building_level: int = 0

var _generation_timer: float = 0.0

# This function is called only when building is placed on island
func activate():
	is_active = true
	_generation_timer = stats.generatingTime

func _process(delta: float) -> void:
	if is_active:
		_generation_timer -= delta
		%GenerationProgressBar.value = get_generation_progress()
		if _generation_timer <= 0:
			generate_resources()
			_generation_timer = stats.generatingTime

func generate_resources():
	for res in stats.generatingResources:
		match building_level:
			0:
				Game.change_player_resource(res, stats.generatingResources[res])
			1:
				Game.change_player_resource(
					res, stats.generatingResources[res] * stats.first_upgrade_multiplier
				)
			2:
				Game.change_player_resource(
					res, stats.generatingResources[res] * stats.second_upgrade_multiplier
				)

func get_generation_progress() -> float:
	return 1.0 - (_generation_timer / stats.generatingTime)

func _on_upgrade_button_pressed() -> void:
	building_level += 1
	if building_level == 2:
		%UpgradeButton.disabled = true
