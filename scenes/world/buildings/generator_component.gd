extends Node
class_name GeneratorComponent

@export var stats: GeneratorStats

@export var generation_progress: float
@export var resource_indicator: HBoxContainer

@export var resource_indicator_starting_position: Vector2

var is_active: bool = false

var _generation_timer: float = 0.0

func _ready() -> void:
	pass

func reload_resource_indicator():
	for key in stats.generatingResources.keys():
		if stats.generatingResources[key] > 0:
			%ResourceNumber.text = "+ " + str(int(stats.generatingResources[key] * get_island_multiplayer(key)))

# This function is called only when building is placed on island
func activate():
	resource_indicator_starting_position = resource_indicator.position
	for key in stats.generatingResources.keys():
		if stats.generatingResources[key] > 0:
			%ResourceNumber.text = "+ " + str(int(stats.generatingResources[key] * get_island_multiplayer(key)))
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

func _physics_process(delta: float) -> void:
	if resource_indicator.visible:
		resource_indicator.position += Vector2(0, -100 * delta)
		if resource_indicator_starting_position.y - resource_indicator.position.y > 100:
			resource_indicator.position = resource_indicator_starting_position
			resource_indicator.visible = false

@rpc("authority", "call_local", "reliable")
func generate_resources():
	if Game.tileMapLayer.tiles[Game.tileMapLayer.local_to_map(owner.global_position)].ownership == Lobby.player_info["color"]:
		for res in stats.generatingResources:
			if stats.generatingResources[res] != 0:
				reload_resource_indicator()
				resource_indicator.visible = true
				Game.change_player_resource(res, int(stats.generatingResources[res] * get_island_multiplayer(res)))
				# play animation here

func get_generation_progress() -> float:
	return 1.0 - (_generation_timer / stats.generatingTime)

func reset_timer():
	_generation_timer = stats.generatingTime
	%GenerationProgressBar.value = get_generation_progress()

func get_island_multiplayer(resource: Game.Resources):
	return owner.get_island().get_resource_bonus(resource)
