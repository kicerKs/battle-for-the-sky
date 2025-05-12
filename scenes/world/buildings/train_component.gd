extends Node
class_name TrainComponent

@export var unit_scene: PackedScene

var new_unit: CharacterBody2D
var unit_stats: UnitStats

var is_active: bool = false

var _current_train_timer: float = 0.0
var _is_training: bool = false
var _spawn_position: Vector2 = Vector2.ZERO
var _training_loop: bool = false

func activate():
	is_active = true
	_spawn_position = get_parent().global_position
	_training_loop = true

func load_unit():
	new_unit = unit_scene.instantiate()
	unit_stats = new_unit.stats

func _process(delta: float) -> void:
	if is_active:
		if _is_training:
			_current_train_timer -= delta
			%UnitTrainProgressBar.value = get_training_progress()
			if _current_train_timer <= 0:
				complete_training()
		if _training_loop:
			start_training()

func start_training():
	if _is_training:
		return false
	
	load_unit()
	for res in unit_stats.trainingResources:
		if Game.get_player_resource(res) < unit_stats.trainingResources[res]:
			return false
	for res in unit_stats.trainingResources:
		Game.change_player_resource(res, -unit_stats.trainingResources[res])
	
	_is_training = true
	_current_train_timer = unit_stats.trainingTime
	return true

func complete_training(): 
	_is_training = false
	get_tree().current_scene.add_child(new_unit)
	new_unit.global_position = _spawn_position
	if _training_loop:
		start_training()

func get_training_progress() -> float:
	return 1.0 - (_current_train_timer / unit_stats.trainingTime)

func _on_button_pressed() -> void:
	if _training_loop:
		%TrainActivateButton.text = "OFF"
	else:
		%TrainActivateButton.text = "ON"
	
	_training_loop = !_training_loop
