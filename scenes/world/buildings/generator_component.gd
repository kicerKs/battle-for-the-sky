extends Node
class_name GeneratorComponent

@export var generation_interval: float = 5.0
@export var generation_resources: Dictionary[Game.Resources, int] = {
	Game.Resources.GOLD: 1,
}
@export var first_upgrade_multiplier: float = 1.25
@export var second_upgrade_multiplier: float = 1.5

var is_active: bool = false
var building_level: int = 0

var _generation_timer: float = 0.0

# This function is called only when building is placed on island
func activate():
	is_active = true
	_generation_timer = generation_interval

func _process(delta: float) -> void:
	if is_active:
		_generation_timer -= delta
		%GenerationProgressBar.value = get_generation_progress()
		if _generation_timer <= 0:
			generate_resources()
			_generation_timer = generation_interval

func generate_resources():
	for res in generation_resources:
		match building_level:
			0:
				Game.change_player_resource(res, generation_resources[res])
			1:
				Game.change_player_resource(res, generation_resources[res] * first_upgrade_multiplier)
			2:
				Game.change_player_resource(res, generation_resources[res] * second_upgrade_multiplier)

func get_generation_progress() -> float:
	return 1.0 - (_generation_timer / generation_interval)

func _on_upgrade_button_pressed() -> void:
	building_level += 1
	if building_level == 2:
		%UpgradeButton.disabled = true
