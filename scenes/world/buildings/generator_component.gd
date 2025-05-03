extends Node
class_name GeneratorComponent

@export var generation_resource: Game.Resources
@export var generation_amount: int = 10
@export var generation_interval: float = 5.0

var is_active: bool = false

var _generation_timer: float = 0.0

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
	Game.change_player_resource(generation_resource, generation_amount)

func get_generation_progress() -> float:
	return 1.0 - (_generation_timer / generation_interval)
