extends Node
class_name GeneratorComponent

@export var stats: GeneratorStats

@export var generation_progress: float

var is_active: bool = false

var _generation_timer: float = 0.0

# This function is called only when building is placed on island
func activate():
	is_active = true
	reset_timer()

func _process(delta: float) -> void:
	%GenerationProgressBar.value = generation_progress
	if is_active:
		_generation_timer -= delta
		if _generation_timer <= 0:
			generate_resources.rpc()
			reset_timer()
		generation_progress = get_generation_progress()

@rpc("authority", "call_local", "reliable")
func generate_resources():
	print(Game.tileMapLayer.local_to_map(owner.global_position))
	if Game.tileMapLayer.tiles[Game.tileMapLayer.local_to_map(owner.global_position)].ownership == Lobby.player_info["color"]:
		for res in stats.generatingResources:
			if stats.generatingResources[res] != 0:
				Game.change_player_resource(res, stats.generatingResources[res])
				# play animation here

func get_generation_progress() -> float:
	return 1.0 - (_generation_timer / stats.generatingTime)

func reset_timer():
	_generation_timer = stats.generatingTime
	%GenerationProgressBar.value = get_generation_progress()
